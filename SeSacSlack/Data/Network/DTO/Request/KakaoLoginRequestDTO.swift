//
//  KakaoLoginRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/9/24.
//

import Foundation


struct KakaoLoginRequestDTO: Encodable {
    let oauthToken: String
    let deviceToken: String
}
