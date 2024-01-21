//
//  ChannelUseCase.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/22/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol ChannelUseCase: AnyObject {
    func searchMyChannels(model: SearchMyChannelsRequestDTO) -> Observable<[SearchMyChannelsResponseDTO]>
}

final class DefaultChannelUseCase: ChannelUseCase {
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func searchMyChannels(model: SearchMyChannelsRequestDTO) -> Observable<[SearchMyChannelsResponseDTO]> {
        return channelRepository.searchMyChannels(model: model)
    }
}