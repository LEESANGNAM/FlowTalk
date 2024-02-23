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
    private let sendSuccess =  BehaviorRelay<Bool>(value: false)
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
        let sendSuccess: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let hiddenImageCollectionView = BehaviorRelay(value: true)
        let sendValid = BehaviorRelay(value: false)
        
        input.viewWillAppearEvent
            .bind(with: self) { owner, _ in
                owner.searchChatting()
                print("채널 채팅 조회함")
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
            chatArray: chatArray,
            sendSuccess: sendSuccess
        )
    }
    
    
    func makeChatting() {
        let text = getContentText()
        
        let model = MakeChattingRequestDTO(name: chatname, workspace_id: WorkSpaceManager.shared.id, content: text, files: imageData.value)
        chattingUseCase.makeChannelChatting(model: model)
            .subscribe(with: self) { owner, value in
//                print("채팅 보내기 성공: ",value)
                owner.chattingUseCase.saveChannelChatting(workspaceId: WorkSpaceManager.shared.id, chattingData: value.toDomain())
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
            } onCompleted: { owner in
                owner.sendSuccess.accept(true)
            }.disposed(by: disposeBag)
    }
    
    func searchChatting() {
        let lastDate = chattingUseCase.checkChattingLastDate(channelId: channelId) ?? ""
        print("마지막 채팅 날짜 체크: ",lastDate)
        let model = SearchChattingRequestDTO(cursor_date: lastDate, workSpaceId: WorkSpaceManager.shared.id, channelName: chatname)
        
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
            }  onCompleted: { owner in
                print("채널채팅조회  완료")// 채팅 조회 완료후 데이터 불러오기
                owner.readData()
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
    private func readData() {
        chattingUseCase.readChannelChatting(channelId: channelId)
            .subscribe(with: self) { owner, chatArray in
                owner.chatArray.accept(chatArray) // 채팅 내역을 전부 가져와서
            } onCompleted: { owner in // 완료 되면 소켓연결
                owner.setSocket()
                owner.recive()
            }.disposed(by: disposeBag)
    }
    private func setSocket() {
        chattingUseCase.socketConfig(channelId: channelId)
        chattingUseCase.socketConnect()
    }
    func recive() {
        chattingUseCase.socketReceive(channelId: channelId)
            .subscribe(with: self) { owner, newchat in
                print("소켓통신중:",newchat)
                var chatArray = owner.chatArray.value
                chatArray.append(newchat.toDomain())
                owner.chatArray.accept(chatArray) // 화면에 추가  디비에도 저장해야함
                owner.chattingUseCase.saveChannelChatting(workspaceId: WorkSpaceManager.shared.id, chattingData: newchat.toSave()) // 디비저장
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
            }.disposed(by: disposeBag)
    }
}


extension ChannelChatiingViewModel {
    func setImageData(_ data: [Data]) {
        print("이미지 데이터 들어옴",data)
        imageData.accept(data)
    }
    func deleteAll() {
        imageData.accept([])
        inputText.accept("")
        sendSuccess.accept(false)
    }
    func deleteImageData(index: Int) {
        var imageArray = imageData.value
        imageArray.remove(at: index)
        imageData.accept(imageArray)
    }
    func getDataCount() -> Int {
        return chatArray.value.count
    }
    func getPlaceHolder() -> String {
        return textViewPlaceHolder
    }
}
