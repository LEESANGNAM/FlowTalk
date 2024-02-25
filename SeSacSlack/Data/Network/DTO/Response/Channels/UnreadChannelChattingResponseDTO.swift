//
//  UnreadChannelChattingResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/25/24.
//

import Foundation

struct UnreadChannelChattingResponseDTO: Decodable {
    let channel_id: Int
    let name: String
    let count: Int
}
