//
//  WorkSpaceListViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

class WorkSpaceListViewModel {
    let disposeBag = DisposeBag()
    let workspaceData = BehaviorRelay<[SearchWorkSpacesResponseDTO]>(value: [])
    private let deleteWorkSpaceSubject = PublishSubject<Void>()
    
    let errorMessage = PublishRelay<String>()
    
    let workspaceUseCase: WorkSpaceUseCase
    init(workspaceUseCase: WorkSpaceUseCase) {
        self.workspaceUseCase = workspaceUseCase
    }
    
    struct Input {
        let viewwillApperEvent: Observable<Void>
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let workspaceData: BehaviorRelay<[SearchWorkSpacesResponseDTO]>
        let addButtonTapped: ControlEvent<Void>
        let errorMessage: PublishRelay<String>

    }
    
    func transform(input: Input) -> Output {
        
        
        input.viewwillApperEvent
            .bind(with: self) { owner, _ in
                WorkSpaceManager.shared.fetchArray()
                
            }.disposed(by: disposeBag)
        
        WorkSpaceManager.shared.workspaceArray
            .bind(to: workspaceData)
            .disposed(by: disposeBag)
        
        return Output(
            workspaceData: workspaceData,
            addButtonTapped: input.addButtonTapped,
            errorMessage: errorMessage
        )
    }
    
    func getworkspaceCount() -> Int {
        return workspaceData.value.count
    }
    
    func getworkSpace(index: Int) -> SearchWorkSpacesResponseDTO {
        let array = workspaceData.value
        return array[index]
    }
    
    func deleteWorkSpace(data: SearchWorkSpacesResponseDTO) {
        let workspace = DeleteWorkSpaceRequestDTO(id: data.workspace_id)
        workspaceUseCase.deleteWorkspace(workspace: workspace)
            .subscribe(with: self) { owner, _ in
            } onError: { owner, error in
                if let networkError = error as? CommonErrorType {
                    print("커먼에러:",networkError.message)
                    let code = networkError.code
                    if let workspaceError = WorkSpaceErrorType(rawValue: code) {
                        print("워크스페이스 에러:",workspaceError.message)
                        owner.errorMessage.accept(workspaceError.message)
                    }
                }
            } onCompleted: { owner in
                WorkSpaceManager.shared.id = 0
                WorkSpaceManager.shared.fetchArrayAndChangeView()
                print("삭제 완료")
            } onDisposed: { owner in
                print("삭제 디스포즈")
            }.disposed(by: self.disposeBag)
    }
    func exitWorkSpace(data: SearchWorkSpacesResponseDTO) {
        let workspace = ExitWorkSpaceRequestDTO(id: data.workspace_id)
        workspaceUseCase.exitWorkSpace(workspace: workspace)
            .subscribe(with: self) { owner, value in
                print("퇴장성공함, 남은데이터: ",value)
                if value.isEmpty {
                    ViewManager.shared.changeRootView(
                        WorkSpaceHomeEmptyViewController()
                    )
                } else {
                    if let firstWorkspace = value.first {
                        let id = firstWorkspace.workspace_id
                        WorkSpaceManager.shared.id = id // 처음 아이디( 최근) 넣고 -> 이동하면 fetch

                        ViewManager.shared.changeRootView(
                            TabbarController()
                        )
                    }
                }
            } onError: { owner, error in
                if let commonError = error as? CommonErrorType {
                    let code = commonError.code
                    if let workspaceError = WorkSpaceErrorType(rawValue: code) {
                        if workspaceError == .exitRejec { // E15 코드면
                            owner.errorMessage.accept(workspaceError.message) // 채널관리자~
                        }
                    }
                }
            } onCompleted: { _ in
                print("퇴장완료")
            } onDisposed: { _ in
                print("디스포즈")
            }.disposed(by: self.disposeBag)
    }
    
    
}
