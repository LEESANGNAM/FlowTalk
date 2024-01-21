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
    
}
