//
//  Router.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    private static let key = APIKey.key
    
    case emailValid(EmailValidationRequestDTO)
    
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }

    private var path: String {
        switch self {
        case .emailValid:
            return "v1/users/validation/email"
        }
    }
    
    
    var header: HTTPHeaders {
        switch self {
        case .emailValid :
            return ["SesacKey": Router.key ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .emailValid:
            return .post
        }
    }

    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
        
        switch self {
        case .emailValid(let emailValidRequestDTO):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(emailValidRequestDTO, into: request)
        }
        return request
    }
    
    
}

