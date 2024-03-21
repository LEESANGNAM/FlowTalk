//
//  DMRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/22/24.
//

import Foundation
import RxSwift

protocol DMRepository: AnyObject {
    func searchMyWorkSpaceDM(model: SearchMyWorkSpaceDMRequestDTO) -> Observable<[SearchMyWorkSpaceDMResponseDTO]>
}
