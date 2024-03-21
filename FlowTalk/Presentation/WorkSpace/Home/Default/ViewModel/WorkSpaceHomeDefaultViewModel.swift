//
//  WorkSpaceHomeDefaultViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import Foundation
import RxSwift
import RxCocoa


struct homeDefaultListItem: Hashable {
    let title: String
    let hasChildren: Bool
    init( title: String = "", hasChildren: Bool = false, unreadCount: Int = 0) {
        self.title = title
        self.hasChildren = hasChildren
        self.unreadCount = unreadCount
    }
    var unreadCount: Int
    private let identifier = UUID()
}
    
class WorkSpaceHomeDefaultViewModel {
    
    let disposeBag = DisposeBag()
    let channelData = BehaviorRelay<[SearchMyChannelsResponseDTO]>(value: [])
    let dmData = BehaviorRelay<[SearchMyWorkSpaceDMResponseDTO]>(value: [])
    
    let homeListData = BehaviorRelay<[[homeDefaultListItem]]>(value: [])
    
    let dmUseCase: DMUseCase
    let channelUseCase: ChannelUseCase
    
    let channelChattingStorage = ChannelChattingStorage()
    init(dmUseCase: DMUseCase, channelUseCase: ChannelUseCase) {
        self.dmUseCase = dmUseCase
        self.channelUseCase = channelUseCase
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let channelData: BehaviorRelay<[SearchMyChannelsResponseDTO]>
        let dmData: BehaviorRelay<[SearchMyWorkSpaceDMResponseDTO]>
        let workspace: PublishRelay<SearchWorkSpaceResponseDTO>
        let homeListData: BehaviorRelay<[[homeDefaultListItem]]>
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                WorkSpaceManager.shared.fetch()
            }.disposed(by: disposeBag)
        
        let workspaceData = PublishRelay<SearchWorkSpaceResponseDTO>()
        
        WorkSpaceManager.shared.workspace
            .bind(with: self) { owner, workspace in
                if let workspace {
                    owner.channeltest(id: workspace.workspace_id)
                    owner.dmtest(id: workspace.workspace_id)
                    workspaceData.accept(workspace)
                }
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(channelData.asObservable(), dmData.asObservable())
            .bind(with: self) { (owner, data) in
                owner.fetchUnreadCount(data.0, data.1)
            }.disposed(by: disposeBag)
        
        
        
        return Output(
            channelData: channelData,
            dmData: dmData,
            workspace: workspaceData,
            homeListData: homeListData
        )
    }
    private func fetchUnreadCount(_ channelData: [SearchMyChannelsResponseDTO], _ dmData: [SearchMyWorkSpaceDMResponseDTO]) {
        if channelData.isEmpty { return }
        
        let group = DispatchGroup()
        
        var homeListArray: [[homeDefaultListItem]] = [[]]
        let workID = WorkSpaceManager.shared.id
        
        var tempchannelArray: [homeDefaultListItem] = Array(repeating: homeDefaultListItem(), count: channelData.count)
        
        var tempdmArray: [homeDefaultListItem] = []
        
        for (index, item) in channelData.enumerated() {
            
            group.enter()
            let LastDate = channelChattingStorage?.checkChattingLastDate(channelId: item.channel_id)
            let model = UnreadChannelChattingRequestDTO(
                workspace_id: workID,
                channelName: item.name,
                after: LastDate ?? ""
            )
    
            channelUseCase.unreadCount(model: model)
                .subscribe(with: self) { owner, unreadChatting in
                    let homeModel = homeDefaultListItem(
                        title: item.name,unreadCount: unreadChatting.count
                    )
                    if index < tempchannelArray.count {
                        tempchannelArray[index] = homeModel
                    }
                    group.leave()
                } onError: { owner, erorr in
                    print("읽지않은채팅 에러")
                    group.leave()
                } onCompleted: { owner in
                    print("읽지않은채팅 완료")
                } onDisposed: { _ in
                    print("읽지않은채팅 디스포즈")
                }.disposed(by: disposeBag)
        }
        
       
        
        for item in dmData {
            group.enter()
            let homeModel = homeDefaultListItem(
                title: item.user.nickname,unreadCount: 10
            )
            tempdmArray.append(homeModel)
            group.leave()
        }
        
        group.notify(queue: .main) {
            homeListArray.append(tempchannelArray)
            homeListArray.append(tempdmArray)
            print("홈리스트 어케되어있는거야",homeListArray)
            self.homeListData.accept(homeListArray)
        }
    }
    
   private func channeltest(id: Int) {
       channelUseCase.searchMyChannels(model: SearchMyChannelsRequestDTO(id: id))
            .subscribe(with: self) { owner, value in
//                print("채널 조회 :",value)
                var array = value
                array.reverse()
                owner.channelData.accept(array)
            } onError: { _, error in
//                print("채널 조회 에러",error)
            } onCompleted: { _ in
//                print("채널조회 완료")
            } onDisposed: { _ in
//                print("채널조회 디스포즈")
            }.disposed(by: disposeBag)

    }
    private func dmtest(id: Int) {
        dmUseCase.searchMyWorkSpaceDM(model: SearchMyWorkSpaceDMRequestDTO(id: id))
            .subscribe(with: self) { owner, value in
//                print("dm 조회 :",value)
                owner.dmData.accept(value)
            } onError: { _, error in
//                print("dm 조회 에러",error)
            } onCompleted: { _ in
//                print("dm 조회 완료")
            } onDisposed: { _ in
//                print("dm 조회 디스포즈")
            }.disposed(by: disposeBag)
    }
    
    
    func getchannelArray() -> [homeDefaultListItem] {
        print(#function)
        return homeListData.value[1]
    }
    func getdmArray() -> [homeDefaultListItem] {
        return homeListData.value[0]
    }
    
    func getChannel(index: Int) -> SearchMyChannelsResponseDTO {
        return channelData.value[index - 1]
    }
    
}
