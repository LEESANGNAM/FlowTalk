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
    let isSuccess = BehaviorRelay(value: false)
    init(workspaceUseCase: WorkSpaceUseCase) {
        self.workspaceUseCase = workspaceUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewDidAppear: Observable<Void>
    }
    
    struct Output {
        let dataArray: BehaviorRelay<[SearchMembersResponseDTO]>
        let arrayEmpty: BehaviorRelay<Bool>
        let isSuccess: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let dataArray = BehaviorRelay<[SearchMembersResponseDTO]>(value: [])
        let arrayEmpty = BehaviorRelay(value: false)
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
        
        input.viewDidAppear
            .withLatestFrom(dataArray)
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    arrayEmpty.accept(true)
                } else {
                    arrayEmpty.accept(false)
                }
            }.disposed(by: disposeBag)
        
        
        return Output(
            dataArray: dataArray,
            arrayEmpty: arrayEmpty,
            isSuccess: isSuccess
        )
    }
    
    func changeAdmin(userId : Int) {
        let workspaceId = WorkSpaceManager.shared.id
        let workspace = WorkSpaceChangeAdminRequestDTO(workspaceId: workspaceId, userId: userId)
        workspaceUseCase.changeAdmin(workspace: workspace)
            .subscribe(with: self) { owner, value in
                print("관리자 변경",value)
            } onError: { owner, error in
                if let commonError = error as? CommonErrorType {
                    let code = commonError.code
                    if let workspaceError = WorkSpaceErrorType(rawValue: code) {
                        print("관리자변경 에러있음",workspaceError.message)
                        owner.isSuccess.accept(false)
                    }
                }
            } onCompleted: { owner in
                print("관리자 변경 성공")
                owner.isSuccess.accept(true)
            } onDisposed: { _ in
                print("관리자변경 디스포즈")
            }.disposed(by: disposeBag)
    }
    
}
