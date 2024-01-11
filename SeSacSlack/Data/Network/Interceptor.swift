//
//  Interceptor.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/11/24.
//

import UIKit
import Alamofire
import RxSwift

class Interceptor: RequestInterceptor {
    let disposeBag = DisposeBag()
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let token = UserDefaultsManager.token
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입 나와라")
        
        if let refreshError = error as? RefreshErrorType {
           print("리프레시 토큰 에러",refreshError.message)
           print("리프레시 토큰 rawvalue",refreshError.rawValue)
            completion(.doNotRetry)
            changeRootView()
            return
        }
        
        if let loginError = error as? LoginSignUpErrorType {
            print("loginError 에러",loginError.message)
            print("loginError rawvalue",loginError.rawValue)
            completion(.doNotRetry)
            return
        }
        
        guard let commonError = error as? CommonErrorType,
              commonError.rawValue == "E05" else {
            print("common 에러 토큰에러 아님")
            completion(.doNotRetry)
            return
        }
        
        
        let result = NetWorkManager.shared.request(type: RefreshTokenResponseDTO.self, api: .refresh)
        result.subscribe(with: self) { owner, value in
            print("리프레시 토큰 성공함")
            UserDefaultsManager.token = value.accessToken
            completion(.retry)
        } onError: { owner, error in
            print("에러 처리함 리프레시 토큰 실패")
            if let refreshError = error as? RefreshErrorType {
               print("리프레시 토큰 에러",refreshError.message)
               print("리프레시 토큰 rawvalue",refreshError.rawValue)
                completion(.doNotRetryWithError(error))
            }
            completion(.doNotRetry)
            return
        } onCompleted: { _ in
            print("리프레시토큰 재발급 완료")
        } onDisposed: { _ in
            print("토큰 재발급 완료 사라짐")
        }.disposed(by: disposeBag)

        
        
    }
    
    private func changeRootView(){
        UserDefaultsManager.resetUserDefaults()
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = OnBoardingViewController()
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}