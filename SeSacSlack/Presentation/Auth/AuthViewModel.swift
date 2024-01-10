//
//  KakaoAuthViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/9/24.
//

import Foundation
import RxSwift
import RxCocoa

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser


class AuthViewModel {
    
    private let loginUseCase: LoginUseCase
    var disposeBag =  DisposeBag()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    let oauthToken = PublishSubject<OAuthToken>()
    let errorMessage = PublishRelay<String>()
    struct Input {
        let appleLoginButtonTap: ControlEvent<Void>
        let kakaoLoginButtonTap: ControlEvent<Void>
        let emailLoginButtonTap: ControlEvent<Void>
        let signUpButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let appleLoginButtonTap: ControlEvent<Void>
        let kakaoLoginButtonTap: ControlEvent<Void>
        let emailLoginButtonTap: ControlEvent<Void>
        let signUpButtonTap: ControlEvent<Void>
        let errorMessage: PublishRelay<String>
        let isSuccess: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        input.kakaoLoginButtonTap
            .bind(with: self) { owner, _ in
                owner.kakaoLogin()
            }.disposed(by: disposeBag)
        
        let isSuccess = PublishRelay<Bool>()
        
        oauthToken
            .withUnretained(self)
            .flatMapLatest { owner, oauthToken in
                let kakaoLoginModel = KakaoLoginRequestDTO(oauthToken: oauthToken.accessToken, deviceToken: "text")
                return owner.loginUseCase.kakaoLogin(user: kakaoLoginModel)
            }.subscribe(with: self) { owner, value in
                print("카카오 로그인 성공함 로그인모델값 :",value)
                
                UserDefaultsManager.saveUserDefaults(
                    id: value.user_id,
                    nickname: value.nickname,
                    token: value.token.accessToken,
                    refresh: value.token.refreshToken
                )
                isSuccess.accept(true)
            }onError: { owner,error  in
                if let networkError = error as? NetWorkErrorType {
                    print("카카오 로그인 에러: ",networkError.message)
                    owner.errorMessage.accept(networkError.message)
                } else {
                    print("다른에러: ", error)
                }
            }onCompleted: { owner in
                print("카카오로그인 완료")
            } onDisposed: { owner in
                print("카카오 로그인 디스포즈")
            }.disposed(by: disposeBag)
        
        
        
        return Output(
            appleLoginButtonTap: input.appleLoginButtonTap,
            kakaoLoginButtonTap: input.kakaoLoginButtonTap,
            emailLoginButtonTap: input.emailLoginButtonTap,
            signUpButtonTap: input.signUpButtonTap,
            errorMessage: errorMessage,
            isSuccess: isSuccess
        )
    }
}



//MARK: - kakaologin
extension AuthViewModel {
    
    
    // login
    func kakaoLogin() {
        print("kakaoAuthVM - \(#function)")
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            kakaoLoginWithApp()
        } else { //카톡 설치 안되어있는경우
            kakaoLoginWithAccount()
        }
    }
    
    // logout
    func kakaoLogout() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
                print("logout() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func kakaoLoginWithApp (){
        //카카오톡 앱으로 인증
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext:{  (oauthToken) in
                print("loginWithKakaoTalk() success.")
                //do something
                print("oauthToken:",oauthToken)
                self.oauthToken.onNext(oauthToken)
            }, onError: {error in
                print(error)
            })
        .disposed(by: disposeBag)
    }
    
    private func kakaoLoginWithAccount() {
        //카카오 계정 로그인
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext:{ (oauthToken) in
                print("loginWithKakaoAccount() success.")
                //do something
                print("oauthToken:",oauthToken)
                self.oauthToken.onNext(oauthToken)
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}


