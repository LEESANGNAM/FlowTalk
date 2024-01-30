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
    func editWorkSpace(workSpace: EditWorkSpaceRequestDTO) -> Observable<EditWorkSpaceResponseDTO>
    func searchWorkSpaces() ->  Observable<[SearchWorkSpacesResponseDTO]>
    func searchWorkSpace(workspace: SearchWorkSpaceRequestDTO) -> Observable<SearchWorkSpaceResponseDTO>
    func deleteWorkspace(workspace: DeleteWorkSpaceRequestDTO) -> Observable<EmptyResponseDTO>
    func workSpaceAddMember(workspace: AddMemberWorkSpaceRequestDTO) -> Observable<AddMemberWorkSpaceResponseDTO>
    func exitWorkSpace(workspace: ExitWorkSpaceRequestDTO) -> Observable<[ExitWorkSpaceResponseDTO]>
    func searchMembers(workspace: SearchMembersRequestDTO) -> Observable<[SearchMembersResponseDTO]>
}

final class DefaultWorkSpaceUseCase: WorkSpaceUseCase {
    private let workSpaceRepository: WorkSpaceRepository
    
    init(workSpaceRepository: WorkSpaceRepository) {
        self.workSpaceRepository = workSpaceRepository
    }
    
    func addWorkSpace(workSpace: AddWorkSpaceRequestDTO) -> RxSwift.Observable<AddWorkSpaceResponseDTO> {
        return workSpaceRepository.addWorkSpace(workspace: workSpace)
    }
    
    func editWorkSpace(workSpace: EditWorkSpaceRequestDTO) -> Observable<EditWorkSpaceResponseDTO> {
        return workSpaceRepository.editWorkSpace(workspace: workSpace)
    }
    
    func searchWorkSpaces() -> RxSwift.Observable<[SearchWorkSpacesResponseDTO]> {
        return workSpaceRepository.searchWorkSpaces()
    }
    
    func searchWorkSpace(workspace: SearchWorkSpaceRequestDTO) -> Observable<SearchWorkSpaceResponseDTO> {
        return workSpaceRepository.searchWorkspace(workspace: workspace)
    }
    
    func deleteWorkspace(workspace: DeleteWorkSpaceRequestDTO) -> Observable<EmptyResponseDTO> {
        return workSpaceRepository.deleteWorkSpace(workspace: workspace)
    }
    
    func workSpaceAddMember(workspace: AddMemberWorkSpaceRequestDTO) -> Observable<AddMemberWorkSpaceResponseDTO> {
        return workSpaceRepository.workSpaceAddMember(workspace: workspace)
    }
    
    func exitWorkSpace(workspace: ExitWorkSpaceRequestDTO) -> Observable<[ExitWorkSpaceResponseDTO]> {
        return workSpaceRepository.exitWorkSpace(workspace: workspace)
    }
    
    func searchMembers(workspace: SearchMembersRequestDTO) -> Observable<[SearchMembersResponseDTO]> {
        return workSpaceRepository.searchMembers(workspace: workspace)
    }
    
}
