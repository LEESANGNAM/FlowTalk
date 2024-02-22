//
//  SocketRouter.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/22/24.
//

import Foundation


enum SocketRouter {
    case channel(id: Int)
    
    var event: String {
        switch self {
        case .channel:
            return "channel"
        }
    }
    
    var path: String {
        switch self {
        case .channel(let id):
            return "/ws-channel-\(id)"
        }
    }
    
    var url: URL {
        return URL(string: APIKey.baseURL + path)!
    }
    
}
