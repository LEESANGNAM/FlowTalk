//
//  SignUpRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/8/24.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let email: String
    let password: String
    let nickName: String
    let phone: String?
    let diviceToken: String?
}
