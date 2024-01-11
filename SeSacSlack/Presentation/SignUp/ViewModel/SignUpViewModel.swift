//
//  SignUpViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

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
    let errorTextfield = PublishRelay<SignUpTextFieldType>()
    
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
        let errorTextfield: PublishRelay<SignUpTextFieldType>
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
            .bind(with: self) { owner, _ in
                let email = owner.emailText // 이메일 텍스트 가져오기
                guard owner.signUseCase.isEmailValid(email: email) else {
                    owner.message.accept("이메일 유효하지않음")
                    self.emailCheck.accept(false)
                    return
                }
                
                // 이미 인증된 상태인 경우에는 다시 요청하지 않음
                guard !owner.emailCheck.value else {
                    owner.message.accept("이미 인증된 이메일")
                    return
                }
                
                owner.signUseCase.emailValidation(email: owner.emailText)
                    .subscribe(with: self) { owner, value in
                        print("이메일 체크 성공 했음",value)
                        owner.message.accept("사용가능한 이메일 입니다.")
                        owner.emailCheck.accept(true)
                    } onError: { owner, error in
                        if let networkError = error as? LoginSignUpErrorType {
                            owner.message.accept(networkError.message)
                            owner.emailCheck.accept(false)
                        }
                    } onCompleted: { _ in
                        print("이메일체크 완료")
                    } onDisposed: { _ in
                        print("이메일 체크 디스포즈")
                    }.disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        
        
        input.signupButtonTap
            .bind(with: self) { owner, _ in
                var errorMessages: [String] = []
                var textfieldArray: [SignUpTextFieldType] = []
                owner.valid()
                
                if !owner.emailCheck.value {
                    errorMessages.append("이메일 중복검사 안함")
                    textfieldArray.append(.emailTextField)
                }
                if !owner.nicknameCheck.value {
                    errorMessages.append("닉네임 유효하지 않음")
                    textfieldArray.append(.nicknameTextField)
                }
                if !owner.phoneNumCheck.value {
                    errorMessages.append("전화번호 유효하지않음")
                    textfieldArray.append(.phoneNumTextField)
                }
                if !owner.passwordCheck.value {
                    errorMessages.append("비밀번호 조건오류")
                    textfieldArray.append(.passwordTextField)
                }
                if !owner.confirmPasswordCheck.value {
                    errorMessages.append("비밀번호 다름")
                    textfieldArray.append(.passwordCheckTextField)
                }
                
                guard errorMessages.isEmpty  else {
                    owner.message.accept("에러 메시지: \(errorMessages.joined(separator: ", "))")
                    if let errorTextfield = textfieldArray.first {
                        owner.errorTextfield.accept(errorTextfield)
                    }
                    return
                }
                
                let email = owner.emailText
                let password = owner.passwordText
                let nickname = owner.nicknameText
                let phone = owner.phoneNumText.value.isEmpty ? "" : owner.phoneNumText.value
                let diviceToken = "testToken"
                
                let user = SignUpRequestDTO(
                    email: email,
                    password: password,
                    nickname: nickname,
                    phone: phone,
                    deviceToken: diviceToken
                )
                
                owner.signUseCase.signUp(user: user)
                    .subscribe(with: self) { owner, value in
                        print("가입하기 탭탭탭")
                        print("가입 성공!:",value)
                        //가입 성공값 저장
                        let userid = value.user_id
                        let nickname = value.nickname
                        let token = value.token.accessToken
                        let refresh = value.token.refreshToken
                        
                        UserDefaultsManager.saveUserDefaults(
                            id: userid,
                            nickname: nickname,
                            token: token,
                            refresh: refresh
                        )
                    } onError: { owner, error in
                        if let networkError = error as? CommonErrorType {
                            owner.message.accept(networkError.message)
                        }
                    } onCompleted: { _ in
                        print("가입하기 완료")
                        owner.changeRootView()
                    } onDisposed: { _ in
                        print("가입하기 디스포즈")
                    }
                    .disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        
        
        return Output(
            emailValid: emailEmptyValid,
            textFieldFill: textFieldFill,
            phoneText: phoneNumText,
            nicknameCheck: nicknameCheck,
            phoneNumCheck: phoneNumCheck,
            passwordCheck: passwordCheck,
            confirmPasswordCheck: confirmPasswordCheck,
            message: message,
            errorTextfield: errorTextfield
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
    
    private func changeRootView(){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let vc = WorkSpaceInitViewController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}

