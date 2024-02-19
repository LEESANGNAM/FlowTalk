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
}
