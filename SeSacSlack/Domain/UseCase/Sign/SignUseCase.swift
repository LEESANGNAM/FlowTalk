//
//  SignUseCase.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/6/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol SignUseCase: AnyObject {
    func emailValidation(email: String) -> Observable<EmptyResponseDTO>
}

final class DefaultSignUseCase: SignUseCase {
    
    private let signReposiroty: SignRepository
    
    init(signReposiroty: SignRepository) {
        self.signReposiroty = signReposiroty
    }
    
    func emailValidation(email: String) -> Observable<EmptyResponseDTO> {
        return signReposiroty.emailVaildation(email: email)
    }
    

}
