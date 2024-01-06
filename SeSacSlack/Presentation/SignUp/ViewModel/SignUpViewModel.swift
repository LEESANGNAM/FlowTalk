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
    var emailCheck = BehaviorRelay(value: false)
    init(signUseCase: SignUseCase) {
        self.signUseCase = signUseCase
    }
    
    struct Input {
        let emailCheckButtonTap: ControlEvent<Void>
        let emailTextFieldChange: ControlProperty<String>
    }
    
    struct Output {
        let emailValid: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let emailValid =  BehaviorRelay<Bool>(value: false)
        input.emailTextFieldChange
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.emailText = text
                owner.emailCheck.accept(false) // 인증 후 텍스트 바꾸면 다시인증
                let isEmail = owner.signUseCase.isTextEmpty(text: text)
                emailValid.accept(isEmail)
            }.disposed(by: disposeBag)
        
        input.emailCheckButtonTap
            .flatMapLatest { [weak self] _ in
                guard let self = self else { return Observable<EmptyResponseDTO>.empty()}
                let email = self.emailText // 이메일 텍스트 가져오기
                
                guard self.signUseCase.isEmail(email: email) else {
                    print("이메일 유효하지않음")
                    self.emailCheck.accept(false)
                    return Observable.empty()
                }
                
                // 이미 인증된 상태인 경우에는 다시 요청하지 않음
                guard !self.emailCheck.value else {
                    print("이미 인증된 이메일")
                    return Observable.empty()
                }
                
                // 유효한 이메일인 경우 서버로 이메일 중복 체크 요청
                return self.signUseCase.emailValidation(email: email)
            }
            .subscribe(with: self) { owner, value in
                print("이메일 체크 성공 했음", value)
                owner.emailCheck.accept(true)
            } onError: { owner, error in
                if let networkError = error as? NetWorkErrorType {
                    print("네트워크에러: ", networkError.message)
                    owner.emailCheck.accept(false)
                }
            } onCompleted: { _ in
                print("이메일체크 완료")
            } onDisposed: { _ in
                print("이메일 체크 디스포즈")
            }
            .disposed(by: disposeBag)
        
        //
        //        input.emailCheckButtonTap
        //            .bind(with: self) { owner, _ in
        //                owner.signUseCase.emailValidation(email: owner.emailText)
        //                    .subscribe(with: self) { owner, value in
        //                        print("이메일 체크 성공 했음",value)
        //                        owner.emailCheck.accept(true)
        //                    } onError: { owner, error in
        //                        if let networkError = error as? NetWorkErrorType {
        //                            print("네트워크에러: ",networkError.message)
        //                            owner.emailCheck.accept(false)
        //                        }
        //                    } onCompleted: { _ in
        //                        print("이메일체크 완료")
        //                    } onDisposed: { _ in
        //                        print("이메일 체크 디스포즈")
        //                    }.disposed(by: owner.disposeBag)
        //            }.disposed(by: disposeBag)
        //
        
        return Output(emailValid: emailValid)
    }
    
    
}

