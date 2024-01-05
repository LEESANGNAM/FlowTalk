//
//  NetWorkManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import Alamofire
import RxSwift

final class NetWorkManager {
    static let shared = NetWorkManager()
    
    private init() { }

    func request<T: Decodable>(type: T.Type, api: Router) -> Observable<T> {
        return Observable<T>.create { observer in
            AF.request(api).validate().responseData { response in
                self.handleResponse(response: response, observer: observer)
            }
            return Disposables.create()
        }
    }
    
    
    private func handleResponse<T: Decodable>(response: AFDataResponse<Data>, observer: AnyObserver<T>) {
        guard let statusCode = response.response?.statusCode else { return }
        print("리스폰스 데이터",String(data: response.data ?? Data() ,encoding: .utf8)!)
        print("response",response)
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
                   guard let data = response.data else { return }
                   let error = try JSONDecoder().decode(ResponseErrorDTO.self, from: data)
                   if let errorType = NetWorkErrorType(rawValue: error.errorCode) {
                       observer.onError(errorType)
                   }
               } catch {
                   print("에러 변환 실패")
                   observer.onError(error)
               }
           default:
               // 기타 상태 코드에 대한 처리
               observer.onError(NetWorkErrorType.badRequest)
           }
        
//            switch response.result {
//            case .success(let data):
//                do {
//                    print("-----------------------------")
//                    print("요청 데이터 용량",data)
//                    
//                    let dataResult = try JSONDecoder().decode(T.self, from: data)
//                    observer.onNext(dataResult)
//                    observer.onCompleted()
//                } catch {
//                    print("리스폰스 변환 실패")
//                }
//            case .failure(let error):
//                do {
//                    guard let data = response.data else { return }
//                    let error = try JSONDecoder().decode(ResponseErrorDTO.self, from: data)
//                    if  let errorType = NetWorkErrorType(rawValue: error.errorCode) {
//                        observer.onError(errorType)
//                    }
//                } catch {
//                    print("에러 변환 실패")
//                }
//                print(error)
//                observer.onError(error)
//            }
        }
    
}
