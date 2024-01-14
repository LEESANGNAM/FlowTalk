//
//  NetWorkManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import UIKit
import Alamofire
import RxSwift

final class NetWorkManager {
    static let shared = NetWorkManager()
    
    private init() { }
    private var originalRequest: Router?
    
    func request<T: Decodable>(type: T.Type, api: Router) -> Observable<T> {
        originalRequest = api
        
        return Observable<T>.create { observer in
            AF.request(api,interceptor: Interceptor()).validate().responseData { response in
                self.handleResponse(response: response, observer: observer)
            }
            return Disposables.create()
        }
    }
    
    func multipartRequst<T: Decodable>(type: T.Type, api: Router) -> Observable<T> {
        originalRequest = api
        
        return Observable<T>.create { observer in
        AF.upload(
            multipartFormData: api.multipart,
            with: api, interceptor: Interceptor()).validate().responseData { response in
                self.handleResponse(response: response, observer: observer)
            }
            return Disposables.create()
        }
    }
    
    private func handleResponse<T: Decodable>(response: AFDataResponse<Data>, observer: AnyObserver<T>) {
        guard let statusCode = response.response?.statusCode else { return }
                print("리스폰스 데이터",String(data: response.data ?? Data() ,encoding: .utf8)!)
        print("리스폰스 결과",response.result)
        print("리스폰스 결과",response.response)
//        print("response왜안나오지?",response.data)
        print("상태코드",statusCode)
        switch statusCode {
        case 200..<300:
            print("성공 했는데 ------------")
            if let data = response.data, !data.isEmpty {
                do {
                    let dataResult = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(dataResult)
                    observer.onCompleted()
                } catch {
                    print("리스폰스 변환 실패")
                    observer.onError(error)
                }
            } else {
                let emptyModel = EmptyResponseDTO() as! T
                observer.onNext(emptyModel)
                observer.onCompleted()
            }
        case 400:
            print("실패 했는데 ------------")
            do {
                print("여기 찍히나?")
                guard let data = response.data else { return }
                print("데이터가 안찍히나",data)
                let error = try JSONDecoder().decode(ResponseErrorDTO.self, from: data)
                print("에러코드 : ",error.errorCode)
                let errorType = hendleError(code: error.errorCode)
                if let commonError = errorType as? CommonErrorType {
                    if commonError.rawValue == "E05" { // 토큰 만료
                        print("토큰 에러 코드 : ",commonError.rawValue)
                        changeToken(observer: observer)
                    } else {
                        observer.onError(commonError)
                    }
                } else if let refreshError = errorType as? RefreshErrorType {
                    if refreshError.rawValue != "E04" {
                        print("리프레쉬 에러")
                        // 리프레쉬 토큰 에러 시 루트 뷰 변경
                        changeRootView()
                        observer.onError(refreshError)
                    }
                } else if let loginError = errorType as? LoginSignUpErrorType {
                    observer.onError(loginError)
                }
                observer.onError(errorType)
            } catch {
                print("에러 변환 실패")
                observer.onError(error)
            }
        default:
            observer.onError(CommonErrorType.serverError)
        }
        
    }
    
    private func changeToken<T: Decodable>(observer: AnyObserver<T>) {
        
        guard let originalRequest = originalRequest else {
            return
        }
        print("토큰 재발급 들어옴")
        request(type: RefreshTokenResponseDTO.self, api: .refresh)
            .subscribe(with: self) { owner, token in
                print("토큰 재발급", token.accessToken)
                // 기존 요청 재시도
                owner.retryOriginalRequest(observer: observer, originalRequest: originalRequest)
            } onError: { owner, error in
                if let refreshError = error as? RefreshErrorType {
                    if refreshError.rawValue != "E04" {
                        print("리프레쉬 에러")
                        // 리프레쉬 토큰 에러 시 루트 뷰 변경
                        owner.changeRootView()
                        observer.onError(refreshError)
                    }
                }
                print("리프레시 토큰 실패")
                observer.onError(error)
            } onCompleted: { _ in
                print("리프레쉬 완료")
            } onDisposed: { _ in
                print("디스포즈")
            }
    }
    
    // 기존 요청 재시도
    private func retryOriginalRequest<T: Decodable>(observer: AnyObserver<T>, originalRequest: Router) {
        print("기존 요청함")
        request(type: T.self, api: originalRequest)
            .subscribe(with: self) { owner, result in
                // 기존 요청 성공 시 처리
                observer.onNext(result)
                observer.onCompleted()
            } onError: { owner, error in
                // 기존 요청 실패 시 처리
                observer.onError(error)
            } onCompleted: { _ in
                print("기존 요청 재시도 완료")
            } onDisposed: { _ in
                print("기존 요청 재시도 디스포즈")
            }
    }
    
    private func hendleError(code: String) -> Error {
        if let commonErrorType = CommonErrorType(rawValue: code) {
            return commonErrorType
        }else if let workspaceError = WorkSpaceErrorType(rawValue: code){
            return workspaceError
        }else if let loginErrorType = LoginSignUpErrorType(rawValue: code) {
            return loginErrorType
        } else if let refreshErrorType = RefreshErrorType(rawValue: code) {
            return refreshErrorType
        } else {
            return CommonErrorType.serverError
        }
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
