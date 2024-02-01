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
                owner.addChannel()
            }.disposed(by: disposeBag)
        
        
        return Output(
            emptyValid: emptyValid,
            isSuccess: isSuccess,
            errormessage: errorMessage)
    }
    
    private func addChannel() {
        let id = WorkSpaceManager.shared.id
        let name = nameText.value
        let info = infoText.value
        let channel = AddChannelRequestDTO(workspace_id: id, name: name , description: info)
        
        channelUseCase.addChannel(channel: channel)
            .subscribe(with: self) { owner, value in
                print("채널 생성 완료: ",value)
            } onError: { owner, error in
                if let commonError = error as? CommonErrorType {
                    let code = commonError.code
                    if let channelError = ChannelsErrorType(rawValue: code){
                        print("채널에러:", channelError.message)
                    }else {
                        print("공용에러:",commonError.message)
                    }
                }
            } onCompleted: { owner in
                print("채널생성 완료")
                owner.isSuccess.accept(true)
            } onDisposed: { _ in
                print("채널생성 디스포즈")
            }.disposed(by: disposeBag)
    }
    
}
