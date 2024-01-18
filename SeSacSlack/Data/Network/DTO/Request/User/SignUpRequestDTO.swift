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
    let nickname: String
    let phone: String?
    let deviceToken: String?
}
