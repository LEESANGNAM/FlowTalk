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
    
    var message: String {
        switch self {
        case .duplicationError:
            return "중복데이터"
        case .badRequest:
            return "잘못된 요청입니다."
        case .coinError:
            return "새싹코인부족"
        }
    }
}
