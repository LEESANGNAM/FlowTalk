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
    case notauth = "E01"
    case overcall = "E98"
    case unownedRouter = "E97"
    case tokenEnd = "E05"
    
    var message: String {
        switch self {
        case .emailValidError:
            return "이미 사용중인 이메일 입니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .loginFalie:
            return "로그인 실패"
        case .overcall:
            return "과호출"
        case .notauth:
            return "권한없음"
        case .unownedRouter:
            return "알수없는 라우터"
        case .tokenEnd:
            return "토큰만료"
        }
    }
    
}
