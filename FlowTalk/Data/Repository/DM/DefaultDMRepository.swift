//
//  DefaultDMRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/22/24.
//

import Foundation
import RxSwift

final class DefaultDMRepository: DMRepository {
    
    func searchMyWorkSpaceDM(model: SearchMyWorkSpaceDMRequestDTO) -> Observable<[SearchMyWorkSpaceDMResponseDTO]> {
        return NetWorkManager.shared.request(type: [SearchMyWorkSpaceDMResponseDTO].self, api: .searchMyDM(model))
    }
    
}
