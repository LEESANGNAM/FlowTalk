//
//  WorkSpaceManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import Foundation
import RxSwift


final class WorkSpaceManager {
    static let shared = WorkSpaceManager()
    var id = UserDefaultsManager.workSpaceId
    private var workspace: SearchWorkSpaceResponseDTO?
    private init(){ }
    let disposeBag = DisposeBag()
    func fetch() {
        print("실행함")
//        guard let id else {
//            print("아이디없음")
//            return }
        let model = SearchWorkSpaceRequestDTO(id: id)
        let result = NetWorkManager.shared.request(type: SearchWorkSpaceResponseDTO.self, api: .searchWorkspace(model))
        
        result.subscribe(with: self) { owner, value in
            print("워크스페이스 한개조회 성공",value)
            owner.workspace = value
        } onError: { owner, error in
            print("error: ",error)
        } onCompleted: { _ in
            print("워크스페이스 한개 조회 성공")
        } onDisposed: { _ in
            print("워크스페이스 한개 조회 디스포즈")
        }.disposed(by: disposeBag)
    }
    
    func setID(_ id: Int) {
        print("아이디넣음")
        self.id = id
    }
    
    func getWorkspace() -> SearchWorkSpaceResponseDTO? {
        return workspace
    }
    
}
