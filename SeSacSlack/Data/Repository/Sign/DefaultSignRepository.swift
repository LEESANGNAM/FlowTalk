//
//  DefaultSignRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import RxSwift

final class DefaultSignRepository: SignRepository {
    
    func emailVaildation(email: String) -> RxSwift.Observable<EmptyResponseDTO> {
        return NetWorkManager.shared.request(type: EmptyResponseDTO.self, api: .emailValid(EmailValidationRequestDTO(email: email)))
    }
}
