//
//  KakaoResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/9/24.
//

import Foundation


struct KakaoResponseDTO: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String?
    let token: TokenResponseDTO
}
