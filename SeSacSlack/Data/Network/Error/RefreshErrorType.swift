//
//  RefreshErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/11/24.
//

import Foundation

enum RefreshErrorType: String, Error {
    case validToken = "E04"
    case unownedUser = "E03"
    case refreshTokenEnd = "E06"
    case authFailed = "E02"
    
    var message: String {
        switch self {
        case .validToken:
            return "유효한토큰"
        case .unownedUser:
            return "알 수 없는 계정"
        case .refreshTokenEnd:
            return "리프레시 토큰 만료"
        case .authFailed:
            return "인증실패"
        }
    }
    
}
