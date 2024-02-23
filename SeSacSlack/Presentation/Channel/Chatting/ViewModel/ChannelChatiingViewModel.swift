//
//  ChannelChatiingViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelChatiingViewModel {
    var chatname = ""
    var channelId: Int
    private let imageData = BehaviorRelay<[Data]>(value: [])
    private let inputText = BehaviorRelay(value: "")
    private let textViewPlaceHolder = "메세지를 입력하세요"
    let chatArray = BehaviorRelay<[ChannelChattingModel]>(value: [])
    let disposeBag = DisposeBag()
    let chattingUseCase: ChannelChattingUseCase
    init(chattingUseCase: ChannelChattingUseCase,channelId: Int) {
        self.chattingUseCase = chattingUseCase
        self.channelId = channelId
    }
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewDidDisappearEvent: Observable<Void>
        let chattingTextViewChange: ControlProperty<String>
        let sendButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let imageData: BehaviorRelay<[Data]>
        let hiddenImageCollectionView: BehaviorRelay<Bool>
        let sendValid: BehaviorRelay<Bool>
        let chatArray: BehaviorRelay<[ChannelChattingModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let hiddenImageCollectionView = BehaviorRelay(value: true)
        let sendValid = BehaviorRelay(value: false)
        
        input.viewWillAppearEvent
            .bind(with: self) { owner, _ in
                owner.searchChatting()
                print("채널 채팅 조회함")
                owner.setSocket(channelId: owner.channelId)
                owner.recive(channelId: owner.channelId)
            }.disposed(by: disposeBag)
        
        input.viewDidDisappearEvent
            .bind(with: self) { owner, _ in
                owner.chattingUseCase.socketDisconnect()
            }.disposed(by: disposeBag)
        
        input.chattingTextViewChange
            .bind(with: self) { owner, text in
                owner.inputText.accept(text)
            }.disposed(by: disposeBag)
        
        imageData.map { $0.isEmpty }
            .bind(to: hiddenImageCollectionView)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(imageData, inputText)
            .map { data,text in
                return !(text.isEmpty || text == self.textViewPlaceHolder) || !data.isEmpty // 비어있으면 false
            }.bind(to: sendValid)
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .bind(with: self) { owner, _ in
                owner.makeChatting()
            }.disposed(by: disposeBag)
        
        
        return Output(
            imageData: imageData,
            hiddenImageCollectionView: hiddenImageCollectionView,
            sendValid: sendValid,
            chatArray: chatArray
        )
    }
    
    func loadChatting() {
        
    }
    
    
    func makeChatting() {
        let text = getContentText()
        
        let model = MakeChattingRequestDTO(name: chatname, workspace_id: WorkSpaceManager.shared.id, content: text, files: imageData.value)
        chattingUseCase.makeChannelChatting(model: model)
            .subscribe(with: self) { owner, value in
//                print("채팅 보내기 성공: ",value)
                owner.chattingUseCase.saveChannelChatting(workspaceId: WorkSpaceManager.shared.id, chattingData: value)
            } onError: { owner, error in
                if let commonError = error as? CommonErrorType {
                    let code = commonError.code
                    if let channelError = ChannelsErrorType(rawValue: code) {
                        print("채널채팅 에러있음: ", channelError.message)
                    } else {
                        print("커먼에러 : ",commonError.message)
                    }
                } else {
                    print("모르는 에러",error)
                }
            } onCompleted: { _ in
                print("채널채팅 보내기 완료")
            } onDisposed: { _ in
                print("채널채팅보내기 디스포즈")
            }.disposed(by: disposeBag)
    }
    
    func searchChatting() {
        let model = SearchChattingRequestDTO(cursor_date: "", workSpaceId: WorkSpaceManager.shared.id, channelName: chatname)
        
        chattingUseCase.searchChannelChatting(model: model)
            .subscribe(with: self) { owner, array in
                for value in array {
                    print("채널 채팅 조회 값 아마 엔티티로 날라옴:", value)
                }
                owner.chattingUseCase.saveChannelChattingArray(workspaceId:  WorkSpaceManager.shared.id, chatArray: array)
            } onError: { owner, error in
                if let commonError = error as? CommonErrorType {
                    let code = commonError.code
                    if let channelError = ChannelsErrorType(rawValue: code) {
                        print("채널채팅조회 에러있음: ", channelError.message)
                    } else {
                        print("커먼에러 : ",commonError.message)
                    }
                } else {
                    print("모르는 에러",error)
                }
            }  onCompleted: { _ in
                print("채널채팅조회  완료")
            } onDisposed: { _ in
                print("채널채팅조회 디스포즈")
            }.disposed(by: disposeBag)

    }
    
    
    func getContentText() -> String?{
        if inputText.value == textViewPlaceHolder {
            return nil
        } else if inputText.value.isEmpty {
            return nil
        } else {
            return inputText.value
        }
    }
}

extension ChannelChatiingViewModel {
    private func setSocket(channelId: Int) {
        chattingUseCase.socketConfig(channelId: channelId)
        chattingUseCase.socketConnect()
    }
    func recive(channelId: Int) {
        chattingUseCase.socketReceive(channelId: channelId)
            .subscribe(with: self) { owner, newchat in
                print("소켓통신중:",newchat)
                var chatArray = owner.chatArray.value
                chatArray.append(newchat)
                owner.chatArray.accept(chatArray) // 화면에 추가  디비에도 저장해야함
            } onError: { owner, error in
                if let commonError = error as? CommonErrorType {
                    let code = commonError.code
                    if let channelError = ChannelsErrorType(rawValue: code) {
                        print("채널채팅 에러있음: ", channelError.message)
                    } else {
                        print("커먼에러 : ",commonError.message)
                    }
                } else {
                    print("모르는 에러",error)
                }
            } onCompleted: { _ in
                print("소켓테스트완료")
            } onDisposed: { _ in
                print("소켓테스트 디스포즈")
            }.disposed(by: disposeBag)
    }
}


extension ChannelChatiingViewModel {
    func setImageData(_ data: [Data]) {
        print("이미지 데이터 들어옴",data)
        imageData.accept(data)
    }
    func deleteImageData(index: Int) {
        var imageArray = imageData.value
        imageArray.remove(at: index)
        imageData.accept(imageArray)
    }
    func getPlaceHolder() -> String {
        return textViewPlaceHolder
    }
}
