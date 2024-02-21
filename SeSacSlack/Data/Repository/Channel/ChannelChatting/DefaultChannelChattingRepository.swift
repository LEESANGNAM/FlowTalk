//
//  DefaultChannelChattingRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation
import RxSwift

class DefaultChannelChattingRepository: ChannelChattingRepository {
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO> {
        return  NetWorkManager.shared.request(type: MakeChattingResponseDTO.self, api: .makeChannelChatting(model))
    }
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]> {
        return NetWorkManager.shared.request(type: [SearchChattingResponseDTO].self, api: .searchChannelChatting(model))
    }
}
