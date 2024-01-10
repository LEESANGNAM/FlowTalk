//
//  EmailLoginViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class EmailLoginViewModel {
    private let loginUseCase: LoginUseCase
    var disposeBag =  DisposeBag()
    
    
    let message =  PublishRelay<String>()
    let errorTextfield = PublishRelay<LoginErrorTextFieldType>()
    
    private var emailText = ""
    private var passwordText = ""
    
    var emailCheck = BehaviorRelay(value: true)
    var passwordCheck = BehaviorRelay(value: true)
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    struct Input {
        let emailTextFieldChange: ControlProperty<String>
        let passwordTextFieldChange: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let message: PublishRelay<String>
        let errorTextfield: PublishRelay<LoginErrorTextFieldType>
        let textFieldFill: BehaviorRelay<Bool>
        let loginButtonTapped: ControlEvent<Void>
        
        let emailCheck: BehaviorRelay<Bool>
        var passwordCheck : BehaviorRelay<Bool>
        
    }
    
    func transform(input: Input) -> Output {
        let emailEmptyValid =  BehaviorRelay(value: false)
        let passwordEmptyValid = BehaviorRelay(value: false)
        
        let textFieldFill = BehaviorRelay(value: false)
        
        Observable.combineLatest(emailEmptyValid, passwordEmptyValid)
            .map { email, password in
                return email && password
            }
            .bind(to: textFieldFill)
            .disposed(by: disposeBag)
        
        input.emailTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.emailText = text
                let isEmail = owner.loginUseCase.isTextEmpty(text: text)
                emailEmptyValid.accept(isEmail)
            }.disposed(by: disposeBag)
        
        input.passwordTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.passwordText = text
                let isPassword = owner.loginUseCase.isTextEmpty(text: text)
                passwordEmptyValid.accept(isPassword)
            }.disposed(by: disposeBag)
        
        input.loginButtonTapped
            .bind(with: self) { owner, _ in
                let emailValid = owner.loginUseCase.isEmailValid(email: owner.emailText)
                let passwordValid = owner.loginUseCase.isPasswordValid(password: owner.passwordText)
                if !emailValid{
                    owner.emailCheck.accept(emailValid)
                    owner.errorTextfield.accept(.emailTextField)
                    owner.message.accept("이메일 형식이 올바르지 않습니다.")
                    return
                } else if !passwordValid {
                    owner.emailCheck.accept(emailValid)
                    owner.passwordCheck.accept(passwordValid)
                    owner.errorTextfield.accept(.passwordTextField)
                    owner.message.accept("비밀번호는 최소 8자이상, 하나 이상의 대소문자/숫자/특수 문자를 설정 해주세요.")
                    return
                } else {
                    owner.passwordCheck.accept(passwordValid)
                }
                print("통과함 요청")
            }.disposed(by: disposeBag)
        
        
        return Output(
            message: message,
            errorTextfield: errorTextfield,
            textFieldFill: textFieldFill,
            loginButtonTapped: input.loginButtonTapped,
            emailCheck: emailCheck,
            passwordCheck: passwordCheck
        )
        
    }
    
}
