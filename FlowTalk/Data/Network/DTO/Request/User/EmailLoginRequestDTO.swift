//
//  EmailLoginRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/11/24.
//

import Foundation

struct EmailLoginRequestDTO: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}
