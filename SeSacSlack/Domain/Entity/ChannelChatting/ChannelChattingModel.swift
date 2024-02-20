//
//  ChannelChattingModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/20/24.
//

import Foundation

struct ChannelChattingModel {
    let chat_id: Int
    let content: String?
    let createdAt: String
    let files: [String]
    
    let user_id: Int
    let username: String
    let userProfileImage: String?
}
