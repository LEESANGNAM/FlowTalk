//
//  DefaultWorkSpaceRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation
import RxSwift
 
final class DefaultWorkSpaceRepository: WorkSpaceRepository {
    
    func addWorkSpace(workspace: AddWorkSpaceRequestDTO) -> Observable<AddWorkSpaceResponseDTO> {
        return NetWorkManager.shared.request(type: AddWorkSpaceResponseDTO.self, api: .addWorkSpace(workspace))
    }
    
    func editWorkSpace(workspace: EditWorkSpaceRequestDTO) -> Observable<EditWorkSpaceResponseDTO> {
        return NetWorkManager.shared.request(type: EditWorkSpaceResponseDTO.self, api: .editWorkSpace(workspace))
    }
    
    func searchWorkSpaces() -> Observable<[SearchWorkSpacesResponseDTO]> {
        return NetWorkManager.shared.request(type: [SearchWorkSpacesResponseDTO].self, api: .searchWorkSpaces)
    }
    
    func searchWorkspace(workspace: SearchWorkSpaceRequestDTO) -> Observable<SearchWorkSpaceResponseDTO> {
        return NetWorkManager.shared.request(type: SearchWorkSpaceResponseDTO.self, api: .searchWorkspace(workspace))
    }
    
    func deleteWorkSpace(workspace: DeleteWorkSpaceRequestDTO) -> Observable<EmptyResponseDTO> {
        return NetWorkManager.shared.request(type: EmptyResponseDTO.self, api: .deleteWorkSpace(workspace))
    }
    
    func workSpaceAddMember(workspace: AddMemberWorkSpaceRequestDTO) -> Observable<AddMemberWorkSpaceResponseDTO> {
        return NetWorkManager.shared.request(type: AddMemberWorkSpaceResponseDTO.self, api: .addMemberWorkspace(workspace))
    }
}
