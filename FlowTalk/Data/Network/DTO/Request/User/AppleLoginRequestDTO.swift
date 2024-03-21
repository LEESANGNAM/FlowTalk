//
//  AppleLoginRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation

struct AppleLoginRequestDTO: Encodable {
    let idToken: String // 애플 계정의 identity Token
    let nickname: String
    let diviceToken: String
}
