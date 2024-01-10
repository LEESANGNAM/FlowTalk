//
//  DefaultLoginRepository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation
import RxSwift

final class DefaultLoginRepository: LoginRespository {
    func kakaoLogin(user: KakaoLoginRequestDTO) -> RxSwift.Observable<KakaoLoginResponseDTO> {
        return NetWorkManager.shared.request(type: KakaoLoginResponseDTO.self, api: .kakaoLogin(user))
    }
    
    func apppleLogin(user: AppleLoginRequestDTO) -> Observable<AppleLoginResponseDTO> {
        return NetWorkManager.shared.request(type: AppleLoginResponseDTO.self, api: .appleLogin(user))
    }
    
    func emailLogin(user: EmailLoginRequestDTO) -> Observable<EmailLoginResponseDTO> {
        return NetWorkManager.shared.request(type: EmailLoginResponseDTO.self, api: .emailLogin(user))
    }
    
}
