//
//  DefaultChannelChattingRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation
import RxSwift

class DefaultChannelChattingRepository: ChannelChattingRepository {
    
    let chattingStorage: ChannelChattingStorage
    
    init(chattingStorage: ChannelChattingStorage) {
        self.chattingStorage = chattingStorage
    }
    
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO> {
        return  NetWorkManager.shared.request(type: MakeChattingResponseDTO.self, api: .makeChannelChatting(model))
    }
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]> {
        return NetWorkManager.shared.request(type: [SearchChattingResponseDTO].self, api: .searchChannelChatting(model))
    }
}

extension DefaultChannelChattingRepository {
    func saveChannelChatting(workspaceId: Int, chattingData: MakeChattingResponseDTO) {
        chattingStorage.addChannelChatting(workspaceId: workspaceId, chattingData: chattingData)
    }
}
