//
//  WorkSpaceRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation
import RxSwift

protocol WorkSpaceRepository: AnyObject {
    func addWorkSpace(workspace: AddWorkSpaceRequestDTO) -> Observable<AddWorkSpaceResponseDTO>
    func editWorkSpace(workspace: EditWorkSpaceRequestDTO) -> Observable<EditWorkSpaceResponseDTO>
    func searchWorkSpaces() ->  Observable<[SearchWorkSpacesResponseDTO]>
    func searchWorkspace(workspace: SearchWorkSpaceRequestDTO) -> Observable<SearchWorkSpaceResponseDTO>
    func deleteWorkSpace(workspace: DeleteWorkSpaceRequestDTO) -> Observable<EmptyResponseDTO>
    func workSpaceAddMember(workspace: AddMemberWorkSpaceRequestDTO) -> Observable<AddMemberWorkSpaceResponseDTO>
}
