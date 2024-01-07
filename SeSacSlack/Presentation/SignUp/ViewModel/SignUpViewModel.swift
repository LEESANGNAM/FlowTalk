//
//  SignUpViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    private let signUseCase: SignUseCase
    var disposeBag =  DisposeBag()
    var emailText = ""
    var nicknameText = ""
    var phoneNumText = BehaviorRelay(value: "")
    var passwordText = ""
    var passwordCheckText = ""
    
    var emailCheck = BehaviorRelay(value: true)
    var nicknameCheck = BehaviorRelay(value: true)
    var phoneNumCheck = BehaviorRelay(value: true)
    var passwordCheck = BehaviorRelay(value: true)
    var confirmPasswordCheck = BehaviorRelay(value: true)
    
    let message =  PublishRelay<String>()
    
    init(signUseCase: SignUseCase) {
        self.signUseCase = signUseCase
    }
    
    struct Input {
        let emailCheckButtonTap: ControlEvent<Void>
        let emailTextFieldChange: ControlProperty<String>
        let nicknameTextFieldChange: ControlProperty<String>
        let phoneNumTextFieldChange: ControlProperty<String>
        let passwordTextFieldChange: ControlProperty<String>
        let passwordCheckTextFieldChange: ControlProperty<String>
        let signupButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailValid: BehaviorRelay<Bool>
        let textFieldFill: BehaviorRelay<Bool>
        let phoneText: BehaviorRelay<String>
        var nicknameCheck : BehaviorRelay<Bool>
        var phoneNumCheck : BehaviorRelay<Bool>
        var passwordCheck : BehaviorRelay<Bool>
        var confirmPasswordCheck : BehaviorRelay<Bool>
        
        let message: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let emailEmptyValid =  BehaviorRelay(value: false)
        let nicknameEmptyValid = BehaviorRelay(value: false)
        let passwordEmptyValid = BehaviorRelay(value: false)
        let passwordChaeckEmptyValid = BehaviorRelay(value: false)
        
        let textFieldFill = BehaviorRelay(value: false)
        
        Observable.combineLatest(emailEmptyValid, nicknameEmptyValid, passwordEmptyValid, passwordChaeckEmptyValid)
            .map { email, nickname, password, confirmPassword in
                return email && nickname && password && confirmPassword
            }
            .bind(to: textFieldFill)
            .disposed(by: disposeBag)
        
        input.emailTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.emailText = text
                owner.emailCheck.accept(false) // 인증 후 텍스트 바꾸면 다시인증
                let isEmail = owner.signUseCase.isTextEmpty(text: text)
                emailEmptyValid.accept(isEmail)
            }.disposed(by: disposeBag)
        
        input.nicknameTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.nicknameText = text
                let isNickname = owner.signUseCase.isTextEmpty(text: text)
                nicknameEmptyValid.accept(isNickname)
            }.disposed(by: disposeBag)
        
        input.phoneNumTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                if text.isEmpty {
                    owner.phoneNumText.accept(text)
                    owner.phoneNumCheck.accept(true)
                } else {
                    let phoneText = text.formated(by: "###-####-####")
                    owner.phoneNumText.accept(phoneText)
                }
            }.disposed(by: disposeBag)
        
        input.passwordTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.passwordText = text
                let isPassword = owner.signUseCase.isTextEmpty(text: text)
                passwordEmptyValid.accept(isPassword)
            }.disposed(by: disposeBag)
        
        input.passwordCheckTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.passwordCheckText = text
                let isConfirmPassword = owner.signUseCase.isTextEmpty(text: text)
                passwordChaeckEmptyValid.accept(isConfirmPassword)
            }.disposed(by: disposeBag)
        
        
        
        input.emailCheckButtonTap
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<EmptyResponseDTO>.empty()}
                let email = self.emailText // 이메일 텍스트 가져오기
                
                guard self.signUseCase.isEmailValid(email: email) else {
                    message.accept("이메일 유효하지않음")
                    self.emailCheck.accept(false)
                    return Observable.empty()
                }
                
                // 이미 인증된 상태인 경우에는 다시 요청하지 않음
                guard !self.emailCheck.value else {
                    message.accept("이미 인증된 이메일")
                    return Observable.empty()
                }
                
                // 유효한 이메일인 경우 서버로 이메일 중복 체크 요청
                return self.signUseCase.emailValidation(email: email)
            }
            .subscribe(with: self) { owner, value in
                print("이메일 체크 성공 했음", value)
                owner.message.accept("사용 가능한 이메일 입니다.")
                owner.emailCheck.accept(true)
            } onError: { owner, error in
                if let networkError = error as? NetWorkErrorType {
                    print("네트워크에러: ", networkError.message)
                    owner.message.accept(networkError.message)
                    owner.emailCheck.accept(false)
                }
            } onCompleted: { _ in
                print("이메일체크 완료")
            } onDisposed: { _ in
                print("이메일 체크 디스포즈")
            }
            .disposed(by: disposeBag)
        
        
        input.signupButtonTap
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<Void>.empty() }
                
                var errorMessages: [String] = []
                
                self.valid()
                
                if !self.emailCheck.value {
                    errorMessages.append("이메일 중복검사 안함")
                }
                if !self.nicknameCheck.value {
                    errorMessages.append("닉네임 유효하지 않음")
                }
                if !self.phoneNumCheck.value {
                    errorMessages.append("전화번호 유효하지않음")
                }
                if !self.passwordCheck.value {
                    errorMessages.append("비밀번호 조건오류")
                }
                if !self.confirmPasswordCheck.value {
                    errorMessages.append("비밀번호 다름")
                }
                
                if errorMessages.isEmpty {
                    // 모든 조건을 통과한 경우에만 가입 요청
                    return Observable.empty()
                } else {
                    // 에러 메시지를 활용하여 뷰에 표시하거나 다른 처리를 수행할 수 있습니다.
                    message.accept("에러 메시지: \(errorMessages.joined(separator: ", "))")
                    return Observable.empty()
                }
            }
            .subscribe(with: self) { owner, _ in
                print("가입하기 탭탭탭")
                //가입 성공값 저장
            } onError: { owner, error in
                if let networkError = error as? NetWorkErrorType {
                    print("네트워크 에러: ", networkError.message)
                }
            } onDisposed: { _ in
                print("가입하기 디스포즈")
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            emailValid: emailEmptyValid,
            textFieldFill: textFieldFill,
            phoneText: phoneNumText,
            nicknameCheck: nicknameCheck,
            phoneNumCheck: phoneNumCheck,
            passwordCheck: passwordCheck,
            confirmPasswordCheck: confirmPasswordCheck,
            message: message
        )
    }
    
    func valid() {
        let nickname = nicknameText
        let nicknameCheckd = signUseCase.isNicknameValid(nickname: nickname)
        nicknameCheck.accept(nicknameCheckd)
        
        let phoneNum = phoneNumText.value
        if !phoneNum.isEmpty {
            let phoneCheckd = signUseCase.isPhoneNumValid(phone: phoneNum)
            phoneNumCheck.accept(phoneCheckd)
        }
        
        let passwordText = passwordText
        let passwordTextCheckd = signUseCase.isPasswordValid(password: passwordText)
        passwordCheck.accept(passwordTextCheckd)
        
        let confirmPassword = passwordCheckText
        let confirmPasswordCheckd = signUseCase.isPasswordConfirmed(password: passwordText, confirmPassword: confirmPassword)
        confirmPasswordCheck.accept(confirmPasswordCheckd)
    }
    
}

