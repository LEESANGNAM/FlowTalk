//
//  AppleLoginResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation

struct AppleLoginResponseDTO: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String?
    let token: TokenResponseDTO
}

