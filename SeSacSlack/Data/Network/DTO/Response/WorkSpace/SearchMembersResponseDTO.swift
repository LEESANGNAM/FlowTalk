//
//  SearchWorkSpaceMemeberResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/31/24.
//

import Foundation

struct SearchMembersResponseDTO: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
