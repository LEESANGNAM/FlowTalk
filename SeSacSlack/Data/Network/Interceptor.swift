//
//  Interceptor.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/11/24.
//

import Foundation
import Alamofire


class Interceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let token = UserDefaultsManager.token
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        print("addtapter",urlRequest.headers)
        completion(.success(urlRequest))
    }
        
}
