//
//  WorkSpaceErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation

enum WorkSpaceErrorType: String, Error {
    case duplicationError = "E12"
    case badRequest = "E11"
    case coinError = "E21"
    case unownedData = "E13"
    case noPermission = "E14"
    case exitRejec = "E15"
    
    var message: String {
        switch self {
        case .duplicationError:
            return "중복데이터"
        case .badRequest:
            return "잘못된 요청입니다."
        case .coinError:
            return "새싹코인부족"
        case .unownedData:
            return "존재하지않는 데이터"
        case .noPermission:
            return "권한없음"
        case .exitRejec:
            return "요청거절,채널관리자는 워크스페이스 못나감"
        }
    }
}
