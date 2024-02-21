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
    
    @Persisted var channelTable: ChannelInfoTable?
    @Persisted var user: ChannelUserInfoTable?
    
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var images: List<String>
    
    convenience init(channelTable: ChannelInfoTable, user: ChannelUserInfoTable, chatting: MakeChattingResponseDTO) {
        self.init()
        self.chat_id = chatting.chat_id
        self.channelTable = channelTable
        self.user = user
        self.content = chatting.content
        self.createdAt = chatting.createdAt
        var images = List<String>()
        images.append(objectsIn: chatting.files)
        self.images = images
    }
    
}
extension ChannelChattingTable {
    func toDomain() -> ChannelChattingModel {
        return ChannelChattingModel(
            chat_id: chat_id,
            content: content,
            createdAt: createdAt,
            files: images.map{$0},
            user_id: user?.user_id ?? -1,
            username: user?.user_name ?? "",
            userProfileImage: user?.user_profile ?? ""
        )
    }
}


class ChannelInfoTable: Object {
    @Persisted(primaryKey: true) var channel_id: Int
    @Persisted var workspace_id: Int
    @Persisted var channel_name: String
    
    convenience init(chatting: MakeChattingResponseDTO, workspace_id: Int) {
        self.init()
        self.channel_id = chatting.channel_id
        self.workspace_id = workspace_id
        self.channel_name = chatting.channelName
    }
}


class ChannelUserInfoTable: Object {
    @Persisted(primaryKey: true) var user_id: Int
    @Persisted var user_name: String
    @Persisted var user_email: String
    @Persisted var user_profile: String?
    
    convenience init(user: MakeChattingUser) {
        self.init()
        self.user_id = user.user_id
        self.user_name = user.nickname
        self.user_email = user.email
        self.user_profile = user.profileImage
    }
}
