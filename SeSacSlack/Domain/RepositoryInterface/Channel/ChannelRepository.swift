//
//  ChannelRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/22/24.
//

import Foundation
import RxSwift

protocol ChannelRepository: AnyObject {
    func searchMyChannels(model: SearchMyChannelsRequestDTO) -> Observable<[SearchMyChannelsResponseDTO]>
    func addChannel(channel: AddChannelRequestDTO) -> Observable<AddChannelResponseDTO>
}
