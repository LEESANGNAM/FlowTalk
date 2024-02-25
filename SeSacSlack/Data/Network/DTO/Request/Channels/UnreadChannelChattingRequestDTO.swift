//
//  UnreadChannelChattingRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/25/24.
//

import Foundation


struct UnreadChannelChattingRequestDTO: Encodable {
    let workspace_id: Int
    let channelName: String
    let after: String
}
