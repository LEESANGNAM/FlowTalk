//
//  SignRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import RxSwift

protocol SignRepository: AnyObject {
    func emailVaildation(email: String) -> Observable<EmptyResponseDTO>
    func signUp(user:SignUpRequestDTO) -> Observable<SignUpResponseDTO>
}
