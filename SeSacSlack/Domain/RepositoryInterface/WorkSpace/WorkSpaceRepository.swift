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
    func searchWorkSpaces() ->  Observable<[SearchWorkSpacesResponseDTO]>
    func searchWorkspace(workspace: SearchWorkSpaceRequestDTO) -> Observable<SearchWorkSpaceResponseDTO>
}
