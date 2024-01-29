//
//  AddMemberViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/29/24.
//

import Foundation
import RxCocoa
import RxSwift

class AddMemberViewModel {
    let disposeBag = DisposeBag()
    var emailText = ""
    
    
    struct Input {
        let emailTextFieldChange: ControlProperty<String>
        let doneButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let isEmptyCheck: BehaviorRelay<Bool>
        let isSuccess: BehaviorRelay<Bool>
        let errorMessage: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let emptyCheck = BehaviorRelay(value: false)
        let isSuccess = BehaviorRelay(value: false)
        let errorMessage = PublishRelay<String>()
        
        input.emailTextFieldChange
            .bind(with: self) { owner, text in
                owner.emailText = text
                let isEmpty = owner.isTextEmpty(text: owner.emailText)
                emptyCheck.accept(isEmpty)
            }.disposed(by: disposeBag)
        
        input.doneButtonTapped
            .bind(with: self) { owner, _ in
                guard owner.isEmailValid(email: owner.emailText) else {
                    errorMessage.accept("올바른 이메일을 입력해 주세요.")
                    return
                }
                
                print("초대 요청")
                let id = WorkSpaceManager.shared.id
                let workspace = AddMemberWorkSpaceRequestDTO(id: id, email: owner.emailText)
                let result = NetWorkManager.shared.request(type: AddMemberWorkSpaceResponseDTO.self, api: .addMemberWorkspace(workspace))
                    result
                    .subscribe(with: self) { owner, value in
                        print("멤버추가 요청 성공:", value)
                    } onError: { _, error in
                        print("멤버추가 error",error)
                    } onCompleted: { _ in
                        print("멤버추가 완료")
                    } onDisposed: { _ in
                        print("멤버추가 디스포즈")
                    }.disposed(by: owner.disposeBag)

                
            }.disposed(by: disposeBag)
        
        
        return Output(
        isEmptyCheck: emptyCheck,
        isSuccess: isSuccess,
        errorMessage: errorMessage
        )
    }
    
    
    private func isTextEmpty(text: String) -> Bool {
        return !text.isEmpty
    }
    
    private func isEmailValid(email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let isValid = emailPredicate.evaluate(with: email) && (email.hasSuffix(".com") || email.hasSuffix(".net") || email.hasSuffix(".co.kr"))
        
        return isValid
    }
    
}
