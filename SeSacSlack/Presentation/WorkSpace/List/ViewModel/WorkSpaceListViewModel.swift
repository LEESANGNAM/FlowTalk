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
    struct Input {
        let viewwillApperEvent: Observable<Void>
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let workspaceData: BehaviorRelay<[SearchWorkSpacesResponseDTO]>
        let addButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        
        input.viewwillApperEvent
            .bind(with: self) { owner, _ in
                WorkSpaceManager.shared.workspaceArray
                    .bind(to: owner.workspaceData)
                    .disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        
        
        return Output(
            workspaceData: workspaceData,
            addButtonTapped: input.addButtonTapped
        )
    }
    
    func getworkspaceCount() -> Int {
        return workspaceData.value.count
    }
    
    func getworkSpace(index: Int) -> SearchWorkSpacesResponseDTO {
        let array = workspaceData.value
        return array[index]
    }
    
    
}
