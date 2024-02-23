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

extension SearchChattingResponseDTO {
    func toDomain() -> ChannelChattingModel {
        return ChannelChattingModel(
            chat_id: chat_id,
            content: content,
            createdAt: createdAt,
            files: files,
            user_id: user.user_id,
            username: user.nickname,
            userProfileImage: user.profileImage)
    }
    
    func toSave() -> SaveChannelChattingDTO {
       return SaveChannelChattingDTO(
            channel_id: channel_id,
            channelName: channelName,
            chat_id: chat_id,
            content: content,
            createdAt: createdAt,
            files: files,
            user: SaveChattingUser(
                user_id: user.user_id,
                email: user.email,
                nickname: user.nickname,
                profileImage: user.profileImage
            )
        )
    }
    
}
