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
    case signUp(SignUpRequestDTO)
    case kakaoLogin(KakaoLoginRequestDTO)
    case appleLogin(AppleLoginRequestDTO)
    case emailLogin(EmailLoginRequestDTO)
    case refresh
    
    case addWorkSpace(AddWorkSpaceRequestDTO)
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }

    private var path: String {
        switch self {
        case .emailValid:
            return "v1/users/validation/email"
        case .signUp:
            return "v1/users/join"
        case .kakaoLogin:
            return "v1/users/login/kakao"
        case .appleLogin:
            return "v1/users/login/apple"
        case .emailLogin:
            return "v2/users/login"
        case .refresh:
            return "v1/auth/refresh"
            
        case .addWorkSpace:
            return "v1/workspaces"
        }
    }
    
    
    var header: HTTPHeaders {
        switch self {
        case .emailValid, .signUp, .kakaoLogin, .appleLogin, .emailLogin:
            return ["SesacKey": Router.key ]
        case .refresh:
            return [
                "SesacKey": Router.key,
                "RefreshToken": UserDefaultsManager.refresh
            ]
        case .addWorkSpace:
            return [
                "Content-Type": "multipart/form-data",
                "SesacKey": Router.key
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .emailValid, .signUp, .kakaoLogin, .appleLogin, .emailLogin,.addWorkSpace:
            return .post
        case .refresh:
            return .get
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
        case .signUp(let signUpRequestDTO):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(signUpRequestDTO, into: request)
        case .kakaoLogin(let kakaoLoginRequestDTO):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(kakaoLoginRequestDTO, into: request)
        case .appleLogin(let appleLoginRequestDTO):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(appleLoginRequestDTO, into: request)
        case .emailLogin(let emailLoginRequestDTO):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(emailLoginRequestDTO, into: request)
        case .refresh, .addWorkSpace:
            break
        }
        return request
    }
    
    
}

extension Router {
    
    var multipart: MultipartFormData {
        switch self {
        case .addWorkSpace(let addWorkSpaceRequestDTO):
            let multipart = MultipartFormData()
            let name = addWorkSpaceRequestDTO.name
            let desctiption = addWorkSpaceRequestDTO.desctiption
            let image = addWorkSpaceRequestDTO.image
            
            multipart.append(name.data(using: .utf8)!, withName: "name")
            if let desctiption {
                multipart.append(desctiption.data(using: .utf8)!, withName: "desctiption")
            }
            multipart.append(image, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            return multipart
            
        default: return MultipartFormData()
        }
    }
    
}
