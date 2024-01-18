//
//  MyInfoManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/18/24.
//

import Foundation
import RxSwift

final class MyInfoManager {
    static let shared = MyInfoManager()
    private let disposeBag = DisposeBag()
    
    var myinfo: MyInfoResponseDTO?
    
    func fetch() {
        let result = NetWorkManager.shared.request(type: MyInfoResponseDTO.self, api: .searchMyInfo)
        
        result.subscribe(with: self) { owner, value in
            print("내정보 가져오기 :",value)
            owner.myinfo = value
        } onError: { _, error in
            print("내정보 못가져옴 에러",error)
        } onCompleted: { _ in
            print("내정보 가져오기 완료 워크스페이스 가져와야지")
        } onDisposed: { _ in
            print("디스포즈")
        }.disposed(by: disposeBag)
    }
    
    
    
    
    
}
