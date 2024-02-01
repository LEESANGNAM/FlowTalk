//
//  channelEditViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelEditViewModel {
    
    let disposeBag = DisposeBag()
    let channelUseCase: ChannelUseCase
    
    init(channelUseCase: ChannelUseCase) {
        self.channelUseCase = channelUseCase
    }
    
    private let errorMessage = PublishRelay<String>()
    let isSuccess = BehaviorRelay(value: false)
    var nameText = BehaviorRelay(value: "")
    var infoText = BehaviorRelay<String?>(value: nil)
    
    struct Input {
        let nameTextFieldChanged: ControlProperty<String>
        let infoTextFieldChanged: ControlProperty<String>
        let doneButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let emptyValid: BehaviorRelay<Bool>
        let isSuccess: BehaviorRelay<Bool>
        let errormessage: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let emptyValid = BehaviorRelay(value: false)
        
        nameText
            .map { !$0.isEmpty }
            .bind(to: emptyValid)
            .disposed(by: disposeBag)
        
        input.nameTextFieldChanged
            .bind(to: nameText)
            .disposed(by: disposeBag)
        
        input.infoTextFieldChanged
            .bind(to: infoText)
            .disposed(by: disposeBag)
        
        input.doneButtonTapped
            .bind(with: self) { owner, _ in
                print("채널생성 ㅎㅎ")
            }.disposed(by: disposeBag)
        
        
        return Output(
            emptyValid: emptyValid,
            isSuccess: isSuccess,
            errormessage: errorMessage)
    }
    
}
