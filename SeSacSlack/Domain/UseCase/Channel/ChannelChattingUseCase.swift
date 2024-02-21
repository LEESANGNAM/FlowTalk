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
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[ChannelChattingModel]>
    
    func saveChannelChatting(workspaceId: Int, chattingData: MakeChattingResponseDTO)
}



final class DefaultChannelChattingUseCase: ChannelChattingUseCase {
    
    private let channelChattingRepository: ChannelChattingRepository
    
    init(channelChattingRepository: ChannelChattingRepository) {
        self.channelChattingRepository = channelChattingRepository
    }
    
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO> {
        return channelChattingRepository.makeChannelChatting(model: model)
    }
    
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[ChannelChattingModel]> {
        return channelChattingRepository.searchChannelChatting(model: model).flatMap { array in
            Observable.just(array.map{ $0.toDomain()})
        }
    }
    
}

extension DefaultChannelChattingUseCase {
    
    func saveChannelChatting(workspaceId: Int, chattingData: MakeChattingResponseDTO) {
        channelChattingRepository.saveChannelChatting(workspaceId: workspaceId, chattingData: chattingData)
    }
}

