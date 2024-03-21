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
            if let multipart = api.multipart {
                AF.upload(
                    multipartFormData: multipart,
                    with: api, interceptor: Interceptor()).validate().responseData { response in
                        self.handleResponse(response: response, observer: observer)
                    }
            } else {
                AF.request(api, interceptor: Interceptor()).validate().responseData { response in
                    self.handleResponse(response: response, observer: observer)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func handleResponse<T: Decodable>(response: AFDataResponse<Data>, observer: AnyObserver<T>) {
        guard let statusCode = response.response?.statusCode else { return }
        //        print("리스폰스 결과",response.result)
        //        print("리스폰스 결과",response.response)
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
//                print("여기 찍히나?")
                guard let data = response.data else { return }
//                print("데이터가 안찍히나",data)
                let error = try JSONDecoder().decode(ResponseErrorDTO.self, from: data)
                print("에러코드 : ",error.errorCode)
                let errorType = hendleError(code: error.errorCode)
                observer.onError(errorType)
            } catch {
                print("에러 변환 실패")
                observer.onError(error)
            }
        default:
            observer.onError(CommonErrorType.serverError("E99"))
        }
        
    }
    
    private func hendleError(code: String) -> Error {
        return CommonErrorType(statusCode: code)
        
//        if let commonErrorType = CommonErrorType(rawValue: code) {
//            return commonErrorType
//        }else if let workspaceError = WorkSpaceErrorType(rawValue: code){
//            return workspaceError
//        }else if let loginErrorType = LoginSignUpErrorType(rawValue: code) {
//            return loginErrorType
//        } else if let refreshErrorType = RefreshErrorType(rawValue: code) {
//            return refreshErrorType
//        } else {
//            return CommonErrorType.serverError
//        }
    }
    
}
