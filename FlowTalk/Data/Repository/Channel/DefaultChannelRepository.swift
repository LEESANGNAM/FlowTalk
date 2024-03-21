//
//  DefaultChannelRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/22/24.
//

import Foundation
import RxSwift

final class DefaultChannelRepository: ChannelRepository {
    
    func searchMyChannels(model: SearchMyChannelsRequestDTO) -> Observable<[SearchMyChannelsResponseDTO]> {
        return NetWorkManager.shared.request(type: [SearchMyChannelsResponseDTO].self, api: .searchMyChannels(model))
    }
    func addChannel(channel: AddChannelRequestDTO) -> Observable<AddChannelResponseDTO> {
        return NetWorkManager.shared.request(type: AddChannelResponseDTO.self, api: .addChannel(channel))
    }
    func unreadCount(model: UnreadChannelChattingRequestDTO) -> Observable<UnreadChannelChattingResponseDTO> {
        return NetWorkManager.shared.request(type: UnreadChannelChattingResponseDTO.self, api: .unreadChannelChatting(model))
    }
}
