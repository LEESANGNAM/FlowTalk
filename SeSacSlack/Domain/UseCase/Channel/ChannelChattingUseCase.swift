//
//  ChannelChattingUseCase.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation
import RxSwift

protocol ChannelChattingUseCase: AnyObject {
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO>
    func checkChattingLastDate(channelId: Int) -> String?
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]>
    
    func saveChannelChatting(workspaceId: Int, chattingData: SaveChannelChattingDTO)
    func saveChannelChattingArray(workspaceId:Int, chatArray: [SearchChattingResponseDTO])
    
    //socket
    //설정
    func socketConfig(channelId: Int)
    //열기
    func socketConnect()
    //받기
    func socketReceive(channelId: Int) -> Observable<SearchChattingResponseDTO>
    //닫기
    func socketDisconnect()
}



final class DefaultChannelChattingUseCase: ChannelChattingUseCase {
    
    private let channelChattingRepository: ChannelChattingRepository
    
    init(channelChattingRepository: ChannelChattingRepository) {
        self.channelChattingRepository = channelChattingRepository
    }
    
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO> {
        return channelChattingRepository.makeChannelChatting(model: model)
    }
    
    func checkChattingLastDate(channelId: Int) -> String? {
        return channelChattingRepository.checkChattingLastDate(channelId: channelId)
    }
    
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]> {
        return channelChattingRepository.searchChannelChatting(model: model)
    }
    
}

extension DefaultChannelChattingUseCase {
    
    func saveChannelChatting(workspaceId: Int, chattingData: SaveChannelChattingDTO) {
        channelChattingRepository.saveChannelChatting(workspaceId: workspaceId, chattingData: chattingData)
    }
    func saveChannelChattingArray(workspaceId:Int, chatArray: [SearchChattingResponseDTO]) {
        channelChattingRepository.saveChannelChattingArray(workspaceId: workspaceId, chatArray: chatArray.map { $0.toSave() })
    }
    
    
}

//MARK: - 소켓
extension DefaultChannelChattingUseCase {
    //설정
    func socketConfig(channelId: Int) {
        channelChattingRepository.socketConfig(channelId: channelId)
    }
    //받기
    func socketReceive(channelId: Int) -> Observable<SearchChattingResponseDTO> {
        return channelChattingRepository.socketReceive(channelId: channelId)
    }
    //연결
    func socketConnect() {
        channelChattingRepository.socketConnect()
    }
    //끊기
    func socketDisconnect() {
        channelChattingRepository.socketDisconnect()
    }
    
}
