//
//  SignUpView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit

class SignUpView: BaseView {
    lazy var emailLabel = createLabel("이메일")
    lazy var nicknameLabel = createLabel("닉네임")
    lazy var phoneNumLabel = createLabel("연락처")
    lazy var passwordLabel = createLabel("비밀번호")
    lazy var passwordCheckLabel = createLabel("비밀번호 확인")
    
    lazy var emailTextField = createTextField("이메일을 입력하세요")
    lazy var nicknameTextField = createTextField("닉네임을 입력하세요")
    lazy var phoneNumTextField = createTextField("전화번호를 입력하세요")
    lazy var passwordTextField = createTextField("비밀번호를을 입력하세요")
    lazy var passwordCheckTextField = createTextField("비밀번호를 한번 더 입력하세요")
    
    let emailCheckButton = CustomBackgroundTitleButton(title: "중복확인", color: Colors.brandInactive.color)
    
    let signUpButton = CustomBackgroundTitleButton(title: "가입하기", color: Colors.brandInactive.color)
    
    override func setHierarchy() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(emailCheckButton)
        
        addSubview(nicknameLabel)
        addSubview(nicknameTextField)
        
        addSubview(phoneNumLabel)
        addSubview(phoneNumTextField)
        
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        
        addSubview(passwordCheckLabel)
        addSubview(passwordCheckTextField)
        
        addSubview(signUpButton)
        
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
        
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
            make.height.equalTo(44)
        }
       
        
    }
    
    
    
    
    private func createTextField(_ placeHolder: String) -> UITextField {
        let view = UITextField()
        let attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: Font.body.fontWithLineHeight()])

        view.attributedPlaceholder = attributedPlaceholder
        view.backgroundColor = Colors.backgroundSecondar.color
        view.layer.cornerRadius = 8
        
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftView = leftPaddingView
        view.leftViewMode = .always
        
        
        return view
    }
    
    private func createLabel(_ text: String) -> UILabel {
        let view = UILabel()
        view.font = Font.title2.fontWithLineHeight()
        view.text = text
        view.tintColor = Colors.brandBlack.color
        return view
    }
    
}
