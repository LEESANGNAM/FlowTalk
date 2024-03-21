//
//  ChannelsErrorType.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/1/24.
//

import Foundation

enum ChannelsErrorType: String, Error {
    case duplicationError = "E12"
    case badRequest = "E11"
    case unownedData = "E13"
    var message: String {
        switch self {
        case .duplicationError:
            return "중복데이터, 이미 있는채널"
        case .badRequest:
            return "잘못된 요청입니다."
        case .unownedData:
            return "존재하지않는 데이터"
        }
    }
}
