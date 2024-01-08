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


class KakaoAuthViewModel {
    let disposeBag = DisposeBag()
    
    var isLogin = BehaviorRelay(value: false)
    lazy var loginStatus = isLogin.flatMap { value in
        return Observable.just(value ? "로그인상태" : "로그아웃 상태")
    }
    
    func kakaoLoginWithApp (){
        //카카오톡 앱으로 인증
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext:{  (oauthToken) in
                print("loginWithKakaoTalk() success.")
                //do something
                _ = oauthToken
                self.isLogin.accept(true)
            }, onError: {error in
                print(error)
                self.isLogin.accept(false)
            })
        .disposed(by: disposeBag)
    }
    
    func kakaoLoginWithAccount() {
        //카카오 계정 로그인
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext:{ (oauthToken) in
                print("loginWithKakaoAccount() success.")
                //do something
                self.isLogin.accept(true)
                _ = oauthToken
            }, onError: {error in
                print(error)
                self.isLogin.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
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
                self.isLogin.accept(false)
            }, onError: {error in
                print(error)
                self.isLogin.accept(true)
            })
            .disposed(by: disposeBag)
    }
}



