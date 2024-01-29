//
//  NetWorkErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation


enum CommonErrorType: Error {
    case notauth(String) // "E01"
    case unownedRouter(String) // "E97"
    case tokenEnd(String) // "E05"
    case authfaild(String) // "E02"
    case unownedUser(String)// "E03"
    case overcall(String) // "E98"
    case serverError(String) // "E99"
    
    case anotherError(String)
    
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
        case .anotherError(_):
            return ""
        }
    }
    var code: String {
        switch self {
        case .notauth(let statusCode),
                .unownedRouter(let statusCode),
                .tokenEnd(let statusCode),
                .authfaild(let statusCode),
                .unownedUser(let statusCode),
                .overcall(let statusCode),
                .serverError(let statusCode),
                .anotherError(let statusCode):
               return statusCode
        }
    }
    
    init(statusCode: String) {
        switch statusCode {
        case "E01": self = .notauth(statusCode)
        case "E97": self = .unownedRouter(statusCode)
        case "E05": self = .tokenEnd(statusCode)
        case "E02": self = .authfaild(statusCode)
        case "E03": self = .unownedUser(statusCode)
        case "E98": self = .overcall(statusCode)
        case "E99": self = .serverError(statusCode)
        default:
            self = .anotherError(statusCode)
        }
    }
    
}
