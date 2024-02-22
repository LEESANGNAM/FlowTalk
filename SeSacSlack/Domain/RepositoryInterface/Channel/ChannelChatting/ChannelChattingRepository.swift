//
//  ChannelChattingRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation
import RxSwift

protocol ChannelChattingRepository: AnyObject {
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO>
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]>
    
    func saveChannelChatting(workspaceId: Int ,chattingData: SaveChannelChattingDTO)
    
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
