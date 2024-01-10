//
//  LoginUseCase.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol LoginUseCase: AnyObject {
    func kakaoLogin(user: KakaoLoginRequestDTO) -> Observable<KakaoLoginResponseDTO>
    func appleLogin(user: AppleLoginRequestDTO) -> Observable<AppleLoginResponseDTO>
    
    func isTextEmpty(text: String) -> Bool
    func isEmailValid(email: String) -> Bool
    func isPasswordValid(password: String) -> Bool
    
}

final class DefaultLoginUseCase: LoginUseCase {

    private let loginRepository: LoginRespository
    
    init(loginRepository: LoginRespository) {
        self.loginRepository = loginRepository
    }
 
    func kakaoLogin(user: KakaoLoginRequestDTO) -> RxSwift.Observable<KakaoLoginResponseDTO> {
        return loginRepository.kakaoLogin(user: user)
    }
    
    func appleLogin(user: AppleLoginRequestDTO) -> Observable<AppleLoginResponseDTO> {
        return loginRepository.apppleLogin(user: user)
    }
    
    func isTextEmpty(text: String) -> Bool {
        return !text.isEmpty
    }
    
    func isEmailValid(email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let isValid = emailPredicate.evaluate(with: email) && (email.hasSuffix(".com") || email.hasSuffix(".net") || email.hasSuffix(".co.kr"))
        
        return isValid
    }
    
    
    func isPasswordValid(password: String) -> Bool {
        // 최소 8자 이상
        // 하나 이상의 대문자, 소문자, 숫자, 특수 문자 포함
        let passwordRegex = #"(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}"#
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
}
