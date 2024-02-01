//
//  AddChannelResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/1/24.
//

import Foundation


struct AddChannelResponseDTO: Decodable {
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
