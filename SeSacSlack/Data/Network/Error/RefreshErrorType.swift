//
//  RefreshErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/11/24.
//

import Foundation

enum RefreshErrorType: String, Error {
    case validToken = "E04"
    case 알수없는계쩡 = "E03"
    case 리프레시토큰만료 = "E06"
    case 인증실패 = "E02"
    
    var message: String {
        switch self {
        case .validToken:
            return "유효한토큰"
        case .알수없는계쩡:
            return "알 수 없는 계정"
        case .리프레시토큰만료:
            return "리프레시 토큰 만료"
        case .인증실패:
            return "인증실패"
        }
    }
    
}
