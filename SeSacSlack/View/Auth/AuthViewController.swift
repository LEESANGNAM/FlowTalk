//
//  AuthViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit


class AuthViewController: BaseViewController {
    let appleLoginButton = SNSLoginButton(
        title: "Apple로 계속하기", icon: Icon.apple.image, titleColor: Colors.brandWhite.color, backgroundColor: Colors.brandBlack.color)
    let kakaoLoginButton = SNSLoginButton(title: "카카오톡으로 계속하기", icon: Icon.kakao.image, titleColor: Colors.brandBlack.color, backgroundColor: Colors.kakao.color)
    let emailLoginButton = SNSLoginButton(title: "이메일로 계속하기", icon: Icon.email.image, titleColor: Colors.brandWhite.color, backgroundColor: Colors.brandGreen.color)
    let signUpButton = SNSLoginButton(title: "또는 새롭게 회원가입 하기", titleColor: Colors.brandBlack.color, backgroundColor: Colors.backgroundPrimary.color)
    
    override func setHierarchy() {
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(signUpButton)
    }
    
    override func setConstraint() {
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-27)
        }
    }
}
