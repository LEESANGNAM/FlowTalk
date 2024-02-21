//
//  ChannelChattingTable.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/21/24.
//

import Foundation
import RealmSwift

class ChannelChattingTable: Object {
    @Persisted(primaryKey: true) var chat_id: Int
    
    @Persisted var channelTable: ChannelTable
    @Persisted var user: ChannelUserTable
    
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var images: List<String>
}
extension ChannelChattingTable {
    func toDomain() -> ChannelChattingModel {
        return ChannelChattingModel(
            chat_id: chat_id,
            content: content,
            createdAt: createdAt,
            files: images.map{$0},
            user_id: user.user_id,
            username: user.user_name,
            userProfileImage: user.user_profile)
    }
}

class ChannelTable: Object {
    @Persisted(primaryKey: true) var channel_id: Int
    @Persisted var workspace_id: Int
    @Persisted var channel_name: String
}

class ChannelUserTable: Object {
    @Persisted(primaryKey: true) var user_id: Int
    @Persisted var user_name: String
    @Persisted var user_email: String
    @Persisted var user_profile: String?
}
