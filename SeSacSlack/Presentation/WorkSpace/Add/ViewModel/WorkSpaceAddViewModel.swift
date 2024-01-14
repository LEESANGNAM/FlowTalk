//
//  WorkSpaceAddViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class WorkSpaceAddViewModel {
    
    let disposeBag = DisposeBag()
    
    private let nameText = BehaviorRelay(value: "")
    private let descriptionText = BehaviorRelay<String?>(value: nil)
    private let imageData = BehaviorRelay<Data?>(value: nil)
    
    private let errorMessage = PublishRelay<String>()
    
    struct Input {
        let nameTextFieldChanged: ControlProperty<String>
        let descriptionTextFieldChanged: ControlProperty<String>
        let doneButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let doneButtonValid: BehaviorRelay<Bool>
        let createSuccess: PublishRelay<Bool>
        let errorMessage: PublishRelay<String>
        let imageData: BehaviorRelay<Data?>
    }
    
    func transform(input: Input) -> Output {
        let imageValid = BehaviorRelay(value: false)
        let textValid = BehaviorRelay(value: false)
        let doneButtonValid = BehaviorRelay(value: false)
        let createSuccess = PublishRelay<Bool>()
        
        imageData.map { $0 != nil }
            .bind(to: imageValid)
            .disposed(by: disposeBag)
        
        input.nameTextFieldChanged
            .distinctUntilChanged()
            .map { $0.count >= 1 && $0.count <= 30 }
            .bind(with: self) { owner, value in
                doneButtonValid.accept(value)
                textValid.accept(value)
            }.disposed(by: disposeBag)
        
        input.nameTextFieldChanged
            .bind(with: self) { owner, text in
                owner.nameText.accept(text)
            }.disposed(by: disposeBag)
        
        input.descriptionTextFieldChanged
            .bind(with: self) { owner, text in
                owner.descriptionText.accept(text)
            }.disposed(by: disposeBag)
        
        input.doneButtonTapped
            .bind(with: self) { owner, _ in
                if !imageValid.value {
                    owner.errorMessage.accept("워크스페이스 이미지를 등록해주세요.")
                } else if !textValid.value {
                    owner.errorMessage.accept("워크 스페이스 이름은 1~30자로 설정해주세요.")
                } else {
                    print("네트워크 요청~~")
                }
                
            }.disposed(by: disposeBag)
        
        
        
        return Output(
            doneButtonValid: doneButtonValid,
            createSuccess: createSuccess,
            errorMessage: errorMessage,
            imageData: imageData
        )
    }
    
    func setImageData(_ imageData: Data?) {
        self.imageData.accept(imageData)
    }
}
