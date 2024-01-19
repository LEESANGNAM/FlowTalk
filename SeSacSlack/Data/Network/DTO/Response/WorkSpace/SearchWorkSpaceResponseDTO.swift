//
//  SearchWorkSpaceResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import Foundation

struct SearchWorkSpaceResponseDTO: Decodable {
    let workspace_id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
    let channels: [SearchWorkSpaceChannel]
    let workspaceMembers: [SearchWorkSpaceMember]
}

struct SearchWorkSpaceChannel: Decodable {
    let workspace_id: Int
    let channel_id: Int
    let name: String
    let description: String?
    let owner_id: Int
    let open: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspace_id, channel_id, name, description, owner_id, createdAt
        case open = "private"
    }
}

struct SearchWorkSpaceMember: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
