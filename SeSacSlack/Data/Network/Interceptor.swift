//
//  Interceptor.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/11/24.
//

import Foundation
import Alamofire
import RxSwift

class Interceptor: RequestInterceptor {
    let disposeBag = DisposeBag()
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let token = UserDefaultsManager.token
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        print("addtapter",urlRequest.headers)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("리트라이 탐")
        guard let _ = request.request?.value(forHTTPHeaderField: "Authorization"),
              request.request?.value(forHTTPHeaderField: "RefreshToken") == nil,
              let response = request.task?.response as? HTTPURLResponse,
                    response.statusCode == 400 else {
                  completion(.doNotRetryWithError(error))
            print("리트라이 나감")
                  return
              }
        
        NetWorkManager.shared.request(type: RefreshTokenResponseDTO.self, api: .refresh)
            .subscribe(with: self) { owner, value in
                print("리프레시 성공")
                UserDefaultsManager.token = value.accessToken
                completion(.retry)
            } onError: { owner, error in
                if let networkError = error as? CommonErrorType {
                    let code = networkError.code
                    if let tokenError = RefreshErrorType(rawValue: code) {
                        switch tokenError {
                        case .validToken:
                            completion(.doNotRetry)
                        case .unownedUser:
                            completion(.doNotRetry)
                            ViewManager.shared.resetRootView()
                        case .refreshTokenEnd:
                            completion(.doNotRetry)
                            ViewManager.shared.resetRootView()
                        case .authFailed:
                            completion(.doNotRetry)
                            ViewManager.shared.resetRootView()
                        }
                    }
                } else {
                    print("리프레시 토큰 에러:",error)
                    completion(.doNotRetryWithError(error))
                }
            } onCompleted: { _ in
                print("리프레시 완료")
            } onDisposed: { _ in
                print("리프레시 디스포즈")
            }.disposed(by: disposeBag)

        
        
    }
        
}
