//
//  DMUseCase.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/22/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol DMUseCase: AnyObject {
    func searchMyWorkSpaceDM(model: SearchMyWorkSpaceDMRequestDTO) -> Observable<[SearchMyWorkSpaceDMResponseDTO]>
}

final class DefaultDMUseCase : DMUseCase {
    let dmRepository: DMRepository
    
    init(dmRepository: DMRepository) {
        self.dmRepository = dmRepository
    }
    
    func searchMyWorkSpaceDM(model: SearchMyWorkSpaceDMRequestDTO) -> Observable<[SearchMyWorkSpaceDMResponseDTO]> {
        return dmRepository.searchMyWorkSpaceDM(model: model)
    }
    
}
