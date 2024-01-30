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
    
    case searchMyInfo
    
    //MARK: - workspace
    case addWorkSpace(AddWorkSpaceRequestDTO)
    case searchWorkSpaces
    case searchWorkspace(SearchWorkSpaceRequestDTO)
    case exitWorkSpace(ExitWorkSpaceRequestDTO)
    case editWorkSpace(EditWorkSpaceRequestDTO)
    case deleteWorkSpace(DeleteWorkSpaceRequestDTO)
    case addMemberWorkspace(AddMemberWorkSpaceRequestDTO)
    case searchMembers(SearchMembersRequestDTO)
    
    
    //MARK: - channel
    case searchMyChannels(SearchMyChannelsRequestDTO)
    
    
    //MARK: - DM
    case searchMyDM(SearchMyWorkSpaceDMRequestDTO)
    
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    private var path: String {
        switch self {
        case .emailValid:
            return "/v1/users/validation/email"
        case .signUp:
            return "/v1/users/join"
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        case .emailLogin:
            return "/v2/users/login"
        case .refresh:
            return "/v1/auth/refresh"
            
        case .searchMyInfo:
            return "/v1/users/my"
            
        case .addWorkSpace, .searchWorkSpaces:
            return "/v1/workspaces"
        case .searchWorkspace(let model):
            return "/v1/workspaces/\(model.id)"
        case .exitWorkSpace(let model):
            return "/v1/workspaces/\(model.id)/leave"
        case .editWorkSpace(let model):
            return "/v1/workspaces/\(model.id)"
        case .deleteWorkSpace(let model):
            return "/v1/workspaces/\(model.id)"
        case .addMemberWorkspace(let model):
            return "/v1/workspaces/\(model.id)/members"
        case .searchMembers(let model):
            return "/v1/workspaces/\(model.id)/members"
            
            
        case .searchMyChannels(let model):
            return "/v1/workspaces/\(model.id)/channels/my"
            
        case .searchMyDM(let model):
            return "/v1/workspaces/\(model.id)/dms"
        }
    }
    
    
    var header: HTTPHeaders {
        switch self {
        case .emailValid, .signUp, .kakaoLogin, .appleLogin, .emailLogin,
                .searchMyInfo,
                .searchWorkSpaces, .searchWorkspace, .exitWorkSpace, .editWorkSpace, .deleteWorkSpace,
                .addMemberWorkspace, .searchMembers,
                .searchMyChannels,
                .searchMyDM:
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
        case .emailValid, .signUp, .kakaoLogin, .appleLogin, .emailLogin,
                .addWorkSpace, .addMemberWorkspace:
            return .post
        case .refresh, .searchMyInfo,
                .searchWorkSpaces, .searchWorkspace, .exitWorkSpace, .searchMembers,
                .searchMyChannels,
                .searchMyDM:
            return .get
        case .editWorkSpace:
            return .put
        case .deleteWorkSpace:
            return .delete
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
        case .addMemberWorkspace(let addMemberWorkSpaceRequestDTO):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(addMemberWorkSpaceRequestDTO, into: request)
        case .refresh, .searchMyInfo,
                .addWorkSpace, .searchWorkSpaces, .searchWorkspace, .exitWorkSpace, .editWorkSpace, .deleteWorkSpace,
                .searchMembers,
                .searchMyChannels,
                .searchMyDM:
            break
        }
        return request
    }
    
    
}

extension Router {
    
    var multipart: MultipartFormData? {
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
            
        case .editWorkSpace(let editWorkSpaceRequestDTO):
            let multipart = MultipartFormData()
            let name = editWorkSpaceRequestDTO.name
            let desctiption = editWorkSpaceRequestDTO.desctiption
            let image = editWorkSpaceRequestDTO.image
            
            multipart.append(name.data(using: .utf8)!, withName: "name")
            if let desctiption {
                multipart.append(desctiption.data(using: .utf8)!, withName: "desctiption")
            }
            multipart.append(image, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            return multipart
            
        default:
            return nil
        }
    }
    
}
