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
    func isTextEmpty(text: String) -> Bool
    
    func isEmailValid(email: String) -> Bool
    func isNicknameValid(nickname: String) -> Bool
    func isPhoneNumValid(phone: String) -> Bool
}

final class DefaultSignUseCase: SignUseCase {
    
    private let signReposiroty: SignRepository
    
    init(signReposiroty: SignRepository) {
        self.signReposiroty = signReposiroty
    }
    
    func emailValidation(email: String) -> Observable<EmptyResponseDTO> {
        return signReposiroty.emailVaildation(email: email)
    }
    func isTextEmpty(text: String) -> Bool {
        return !text.isEmpty
    }
    
    func isEmailValid(email: String) -> Bool {
        // 이메일 유효성 검증 로직 추가
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email) && email.hasSuffix(".com")
    }
    
    func isNicknameValid(nickname: String) -> Bool {
        return nickname.count >= 1 && nickname.count <= 30
    }
    
    func isPhoneNumValid(phone: String) -> Bool {
        let phoneNumberRegex = "^01[0-1, 7][0-9]{7,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return predicate.evaluate(with: phone)
    }
    
    
}
