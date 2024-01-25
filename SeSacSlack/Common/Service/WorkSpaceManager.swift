//
//  WorkSpaceManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import Foundation
import RxSwift
import RxRelay


final class WorkSpaceManager {
    static let shared = WorkSpaceManager()
    private init(){ }
    
    
    var id = UserDefaultsManager.workSpaceId
    var workspace = BehaviorRelay<SearchWorkSpaceResponseDTO?>(value: nil)
    var workspaceArray = BehaviorRelay<[SearchWorkSpacesResponseDTO]>(value: [])
    let disposeBag = DisposeBag()
    
    func fetch() {
        let model = SearchWorkSpaceRequestDTO(id: id)
        let result = NetWorkManager.shared.request(type: SearchWorkSpaceResponseDTO.self, api: .searchWorkspace(model))
        
        result.subscribe(with: self) { owner, value in
            print("워크스페이스 한개조회 성공",value)
            UserDefaultsManager.workSpaceId = value.workspace_id
            owner.workspace.accept(value)
        } onError: { owner, error in
            print("error: ",error)
        } onCompleted: { _ in
            print("워크스페이스 한개 조회 성공")
        } onDisposed: { _ in
            print("워크스페이스 한개 조회 디스포즈")
        }.disposed(by: disposeBag)
    }
    
    func fetchArray() {
        NetWorkManager.shared.request(type: [SearchWorkSpacesResponseDTO].self, api: .searchWorkSpaces)
            .subscribe(with: self) { owner, value in
                print("워크스페이스 확인 ",value)
                owner.workspaceArray.accept(value)
                if value.isEmpty {
                    ViewManager.shared.changeRootView(WorkSpaceHomeEmptyViewController())
                } else {
                    print("마지막 접속 id: ",owner.id)
                    if owner.id == 0 {
                        let workspaceID = value[0].workspace_id
                        owner.id = workspaceID
                    }
                    ViewManager.shared.changeRootView(
                        TabbarController()
                    )
                }
            } onError: { owner, error in
                print("워크스페이스 에러:",error)
            } onCompleted: { owner in
                print("워크스페이스 찾기 완료")
            } onDisposed: { _ in
                print("워크스페이스 찾기 디스포즈")
            }.disposed(by: disposeBag)
    }
    
    func setID(_ id: Int) {
        if self.id == id {
            return
        }
        print("아이디넣음")
        self.id = id
        fetch()
    }
    
    
}
