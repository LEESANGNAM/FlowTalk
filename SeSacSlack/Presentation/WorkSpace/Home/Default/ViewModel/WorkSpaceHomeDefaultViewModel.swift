//
//  WorkSpaceHomeDefaultViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import Foundation
import RxSwift
import RxCocoa


class WorkSpaceHomeDefaultViewModel {
    
    let disposeBag = DisposeBag()
    let channelData = BehaviorRelay<[SearchMyChannelsResponseDTO]>(value: [])
    let dmData = BehaviorRelay<[SearchMyWorkSpaceDMResponseDTO]>(value: [])
    
    let dmUseCase: DMUseCase
    let channelUseCase: ChannelUseCase
    
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
        
        return Output(
            channelData: channelData,
            dmData: dmData,
            workspace: workspaceData
        )
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
    
    func getchannelArray() -> [SearchMyChannelsResponseDTO] {
        return channelData.value
    }
    func getdmArray() -> [SearchMyWorkSpaceDMResponseDTO] {
        return dmData.value
    }
    
    func getChannel(index: Int) -> SearchMyChannelsResponseDTO {
        return channelData.value[index - 1]
    }
    
}
