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
}
