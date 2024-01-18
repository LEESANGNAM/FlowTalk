//
//  WorkSpaceUseCase.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol WorkSpaceUseCase: AnyObject {
    func addWorkSpace(workSpace: AddWorkSpaceRequestDTO) -> Observable<AddWorkSpaceResponseDTO>
    func searchWorkSpaces() ->  Observable<[SearchWorkSpacesResponseDTO]>
}

final class DefaultWorkSpaceUseCase: WorkSpaceUseCase {
    private let workSpaceRepository: WorkSpaceRepository
    
    init(workSpaceRepository: WorkSpaceRepository) {
        self.workSpaceRepository = workSpaceRepository
    }
    
    func addWorkSpace(workSpace: AddWorkSpaceRequestDTO) -> RxSwift.Observable<AddWorkSpaceResponseDTO> {
        return workSpaceRepository.addWorkSpace(workspace: workSpace)
    }
    
    func searchWorkSpaces() -> RxSwift.Observable<[SearchWorkSpacesResponseDTO]> {
        return workSpaceRepository.searchWorkSpaces()
    }
   
}
