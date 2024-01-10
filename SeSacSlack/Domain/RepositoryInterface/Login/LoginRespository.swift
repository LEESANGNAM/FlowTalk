//
//  LoginRespository.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation
import RxSwift

protocol LoginRespository: AnyObject {
    func kakaoLogin(user: KakaoLoginRequestDTO) -> Observable<KakaoLoginResponseDTO>
    func apppleLogin(user: AppleLoginRequestDTO) -> Observable<AppleLoginResponseDTO>
    func emailLogin(user: EmailLoginRequestDTO) ->Observable<EmailLoginResponseDTO>
}
