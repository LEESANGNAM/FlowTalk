//
//  SearchMyChannelsResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import Foundation


struct SearchMyChannelsResponseDTO: Decodable {
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
