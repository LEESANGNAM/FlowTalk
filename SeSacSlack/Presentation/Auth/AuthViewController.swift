//
//  AuthViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa


class AuthViewController: BaseViewController {
    let appleLoginButton = SNSLoginButton(
        icon: Icon.apple.image, title: "Apple로 계속하기", titleColor: Colors.brandWhite.color, backgroundColor: Colors.brandBlack.color)
    let kakaoLoginButton = SNSLoginButton(icon: Icon.kakao.image, title: "카카오톡으로 계속하기", titleColor: Colors.brandBlack.color, backgroundColor: Colors.kakao.color)
    let emailLoginButton = SNSLoginButton(icon: Icon.email.image, title: "이메일로 계속하기", titleColor: Colors.brandWhite.color, backgroundColor: Colors.brandGreen.color)
    let signUpButton = SNSLoginButton(title: "또는",subtitle: " 새롭게 회원가입 하기", titleColor: Colors.brandBlack.color,subtitleColor: Colors.brandGreen.color, backgroundColor: Colors.backgroundPrimary.color)
    
    let kakaoAuthVM = KakaoAuthViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignUpButton()
        testkakaoButton()
        bind()
    }
    private func bind() {
        kakaoAuthVM.oauthToken
            .flatMapLatest { oauthToken in
                let kakaoLoginModel = KakaoLoginRequestDTO(oauthToken: oauthToken.accessToken, deviceToken: "text")
                return NetWorkManager.shared.request(type: KakaoResponseDTO.self, api: .kakaoLogin(kakaoLoginModel))
            }.subscribe(with: self) { owner, value in
                print("카카오 로그인 성공함 로그인모델값 :",value)
            }onError: { owner,error  in
                if let networkError = error as? NetWorkErrorType {
                    print("카카오 로그인 에러: ",networkError.message)
                } else {
                    print("다른에러: ", error)
                }
            }onCompleted: { owner in
                print("카카오로그인 완료")
            } onDisposed: { owner in
                print("카카오 로그인 디스포즈")
            }.disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(signUpButton)
    }
    
    override func setConstraint() {
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(44)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(20)
        }
    }
}

extension AuthViewController {
    private func testkakaoButton(){
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    @objc
    private func kakaoLoginButtonTapped(){
        print("로그인 테스트")
        kakaoAuthVM.kakaoLogin()
    }
    
    
    private func setSignUpButton(){
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func signUpButtonTapped() {
        let vc = SignUpViewController(
            viewModel: SignUpViewModel(
                signUseCase: DefaultSignUseCase(
                    signReposiroty: DefaultSignRepository()
                )
            )
        )
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
    
}
