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
        let emailCheck: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        input.emailTextFieldChange
            .bind(with: self) { owner, text in
                owner.emailText = text
            }.disposed(by: disposeBag)
        
        
        input.emailCheckButtonTap
            .bind(with: self) { owner, _ in
                owner.signUseCase.emailValidation(email: owner.emailText)
                    .subscribe(with: self) { owner, value in
                        print("이메일 체크 성공 했음",value)
                        owner.emailCheck.accept(true)
                    } onError: { owner, error in
                        if let networkError = error as? NetWorkErrorType {
                            print("네트워크에러: ",networkError.message)
                            owner.emailCheck.accept(false)
                        }
                    } onCompleted: { _ in
                        print("이메일체크 완료")
                    } onDisposed: { _ in
                        print("이메일 체크 디스포즈")
                    }.disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        

        return Output(emailCheck: emailCheck)
    }
    
    
}

