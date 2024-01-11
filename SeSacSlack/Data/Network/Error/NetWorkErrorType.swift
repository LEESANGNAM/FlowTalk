//
//  NetWorkErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation

enum CommonErrorType: String, Error {
    case notauth = "E01"
    case unownedRouter = "E97"
    case tokenEnd = "E05"
    case authfaild = "E02"
    case unownedUser = "E03"
    case overcall = "E98"
    case serverError = "E99"
    
    var message: String {
        switch self {
        case .notauth:
            return "권한없음"
        case .unownedRouter:
            return "알수없는 라우터"
        case .tokenEnd:
            return "토큰만료"
        case .authfaild:
            return "인증 실패"
        case .unownedUser:
            return "알 수 없는 유저"
        case .overcall:
            return "과호출"
        case .serverError:
            return "서버 점검중"
            
        }
    }
    
}
