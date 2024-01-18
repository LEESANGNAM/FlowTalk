//
//  MyInfoResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/18/24.
//

import Foundation

struct MyInfoResponseDTO: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let sesacCoin: Int
    let createdAt: String
}
