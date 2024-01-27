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
        let deleteSuccess: Observable<Void>

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
            deleteSuccess: deleteWorkSpaceSubject.asObservable()
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
                print("삭제 에러있음",error)
            } onCompleted: { owner in
                WorkSpaceManager.shared.id = 0
                WorkSpaceManager.shared.fetchArray()
                print("삭제 완료")
                owner.deleteWorkSpaceSubject.onNext(())
            } onDisposed: { owner in
                print("삭제 디스포즈")
            }.disposed(by: self.disposeBag)
    }
    
    
}
