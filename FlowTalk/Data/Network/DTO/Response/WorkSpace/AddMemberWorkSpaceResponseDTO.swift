//
//  AddMemberWorkSpaceResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/29/24.
//

import Foundation

struct AddMemberWorkSpaceResponseDTO: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
