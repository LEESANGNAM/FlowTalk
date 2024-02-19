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
}



final class DefaultChannelChattingUseCase: ChannelChattingUseCase {
    
    private let channelChattingRepository: ChannelChattingRepository
    
    init(channelChattingRepository: ChannelChattingRepository) {
        self.channelChattingRepository = channelChattingRepository
    }
    
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO> {
        return channelChattingRepository.makeChannelChatting(model: model)
    }
    
}

