//
//  TokenResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/9/24.
//

import Foundation


struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
