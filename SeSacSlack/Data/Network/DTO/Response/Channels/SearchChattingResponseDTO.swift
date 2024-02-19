//
//  SearchChattingResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/19/24.
//

import Foundation

struct SearchChattingResponseDTO: Decodable {
        let channel_id: Int
        let channelName: String
        let chat_id: Int
        let content: String?
        let createdAt: String
        let files: [String]
        let user: SearchChattingUser
}

struct SearchChattingUser: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
