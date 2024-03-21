//
//  SearchChattingRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation

struct SearchChattingRequestDTO: Encodable {
    let cursor_date: String
    let workSpaceId: Int
    let channelName: String
}
