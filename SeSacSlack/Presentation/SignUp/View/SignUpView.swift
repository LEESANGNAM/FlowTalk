//
//  SignUpView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit

class SignUpView: BaseView {
    lazy var emailLabel = CustomTitle2BlackLabel(text: "이메일")
    lazy var nicknameLabel = CustomTitle2BlackLabel(text: "닉네임")
    lazy var phoneNumLabel = CustomTitle2BlackLabel(text: "연락처")
    lazy var passwordLabel = CustomTitle2BlackLabel(text: "비밀번호")
    lazy var passwordCheckLabel = CustomTitle2BlackLabel(text: "비밀번호 확인")
    
    lazy var emailTextField = CustomPlaceHolderTextField("이메일을 입력하세요")
    lazy var nicknameTextField = CustomPlaceHolderTextField("닉네임을 입력하세요")
    lazy var phoneNumTextField = CustomPlaceHolderTextField("전화번호를 입력하세요")
    lazy var passwordTextField = CustomPlaceHolderTextField("비밀번호를을 입력하세요")
    lazy var passwordCheckTextField = CustomPlaceHolderTextField("비밀번호를 한번 더 입력하세요")
    
    let emailCheckButton = CustomBackgroundTitleButton(title: "중복확인", color: Colors.brandInactive.color)
    
    let signUpBackView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundPrimary.color
        return view
    }()
    let signUpButton = CustomBackgroundTitleButton(title: "가입하기", color: Colors.brandInactive.color)
    
    override func setHierarchy() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(emailCheckButton)
        
        addSubview(nicknameLabel)
        addSubview(nicknameTextField)
        
        addSubview(phoneNumLabel)
        addSubview(phoneNumTextField)
        phoneNumTextField.keyboardType = .numberPad
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        
        addSubview(passwordCheckLabel)
        addSubview(passwordCheckTextField)
        addSubview(signUpBackView)
        
        signUpBackView.addSubview(signUpButton)
        
    }
    
    override func setConstraint() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(44)
        }
        emailCheckButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(emailTextField.snp.trailing).offset(12)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        
        phoneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        
        passwordCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        signUpBackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(68)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
       
        
    }
    
}
