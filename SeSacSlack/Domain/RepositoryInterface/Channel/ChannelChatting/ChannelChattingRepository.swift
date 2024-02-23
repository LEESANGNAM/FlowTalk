//
//  ChannelChattingRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation
import RxSwift
import RealmSwift

protocol ChannelChattingRepository: AnyObject {
    func makeChannelChatting(model: MakeChattingRequestDTO) -> Observable<MakeChattingResponseDTO>
    
    func checkChattingLastDate(channelId: Int) -> String?
    func searchChannelChatting(model: SearchChattingRequestDTO) -> Observable<[SearchChattingResponseDTO]>
    
    func readChannelChatting(channelId: Int) -> [ChannelChattingTable]
    
    //저장
    func saveChannelChatting(workspaceId: Int ,chattingData: SaveChannelChattingDTO)
    func saveChannelChattingArray(workspaceId:Int, chatArray: [SaveChannelChattingDTO])
    
    
    
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
