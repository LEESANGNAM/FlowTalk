//
//  SearchMyWorkSpaceDMResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/21/24.
//

import Foundation

struct SearchMyWorkSpaceDMResponseDTO: Decodable {
    let workspace_id: Int
    let room_id: Int
    let createdAt: String
    let user: DMUser
}

struct DMUser: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
