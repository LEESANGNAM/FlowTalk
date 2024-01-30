//
//  WorkSpaceChangeAdminViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/31/24.
//

import Foundation
import RxSwift
import RxCocoa

class WorkSpaceChangeAdminViewModel {
    
    let disposeBag = DisposeBag()
    
    let workspaceUseCase: WorkSpaceUseCase
    
    init(workspaceUseCase: WorkSpaceUseCase) {
        self.workspaceUseCase = workspaceUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let dataArray: BehaviorRelay<[SearchMembersResponseDTO]>
    }
    
    func transform(input: Input) -> Output {
        let dataArray = BehaviorRelay<[SearchMembersResponseDTO]>(value: [])
        
        input.viewDidLoadEvent
            .bind(with: self) { owner, _ in
                let workspace = SearchMembersRequestDTO(id: WorkSpaceManager.shared.id)
                owner.workspaceUseCase.searchMembers(workspace: workspace)
                    .subscribe(with: self) { owner, value in
                        print("멤버찾기 성공",value)
                        // 여기서 특정 조건에 맞는 데이터만 추출하여 새로운 배열을 만듭니다.
                        if let myid = MyInfoManager.shared.myinfo?.user_id{
                            let filteredData = value.filter { $0.user_id != myid }
                            dataArray.accept(filteredData)
                        }
                    } onError: { owner, error in
                        if let commonError = error as? CommonErrorType {
                            let code = commonError.code
                            if let workspaceError = WorkSpaceErrorType(rawValue: code) {
                                print("워크스페이스 에러있음",workspaceError.message)
                            }
                        }
                    } onCompleted: { _ in
                        print("멤버찾기 완료")
                    } onDisposed: { _ in
                        print("멤버찾기 디스포즈")
                    }.disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        
        return Output(
            dataArray: dataArray
        )
    }
    
}
