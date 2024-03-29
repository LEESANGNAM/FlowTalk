//
//  DefaultChannelChattingRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation
import RxSwift
import RealmSwift

class DefaultChannelChattingRepository: ChannelChattingRepository {
    
    let chattingStorage: ChannelChattingStorage
    
    init(chattingStorage: ChannelChattingStorage) {
        self.chattingStorage = chattingStorage
    }
    
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO> {
        return  NetWorkManager.shared.request(type: MakeChattingResponseDTO.self, api: .makeChannelChatting(model))
    }
    
    func checkChattingLastDate(channelId: Int) -> String? {
        return chattingStorage.checkChattingLastDate(channelId: channelId)
    }
    
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]> {
        return NetWorkManager.shared.request(type: [SearchChattingResponseDTO].self, api: .searchChannelChatting(model))
    }
    
    func readChannelChatting(channelId: Int) -> [ChannelChattingTable] {
        return chattingStorage.readChannelChatting(channelId: channelId)
    }
}

// 저장
extension DefaultChannelChattingRepository {
    func saveChannelChatting(workspaceId: Int, chattingData: SaveChannelChattingDTO) {
        chattingStorage.addChannelChatting(workspaceId: workspaceId, chattingData: chattingData)
    }
    
    func saveChannelChattingArray(workspaceId:Int, chatArray: [SaveChannelChattingDTO]) {
        chatArray.forEach { data in
            chattingStorage.addChannelChatting(workspaceId: workspaceId, chattingData: data)
        }
    }
}

// socket
extension DefaultChannelChattingRepository {
    func socketConfig(channelId: Int) {
        SocketIOManager.shared.config(type: .channel(id: channelId))
    }
    
    func socketReceive(channelId: Int) -> Observable<SearchChattingResponseDTO> {
        return SocketIOManager.shared.receive(type: SearchChattingResponseDTO.self, api: .channel(id: channelId))
    }
    
    func socketConnect() {
        SocketIOManager.shared.connect()
    }
    
    func socketDisconnect() {
        SocketIOManager.shared.disconnect()
    }
}
