//
//  NetWorkErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation

enum NetWorkErrorType: String, Error {
    case emailValidError = "E12"
    case badRequest = "E11"
    case loginFalie = "E03"
    
    var message: String {
        switch self {
        case .emailValidError:
            return "이미 사용중인 이메일 입니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .loginFalie:
            return "로그인 실패"
        }
    }
    
}
