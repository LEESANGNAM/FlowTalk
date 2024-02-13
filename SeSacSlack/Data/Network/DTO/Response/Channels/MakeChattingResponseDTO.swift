//
//  MakeChattingResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/13/24.
//

import Foundation

struct MakeChattingResponseDTO: Decodable {
    let channel_id: Int
    let channelName: String
    let chat_id: Int
    let content: String?
    let createdAt: String
    let files: [String]
    let user: MakeChattingUser
}

struct MakeChattingUser: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
