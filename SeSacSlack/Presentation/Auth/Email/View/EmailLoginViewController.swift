//
//  EmailLoginViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import UIKit

class EmailLoginViewController: BaseViewController {
    let emailLabel = CustomTitle2BlackLabel(text: "이메일")
    let passwordLabel = CustomTitle2BlackLabel(text: "비밀번호")
    
    let emailTextField = CustomPlaceHolderTextField("이메일을 입력하세요")
    let passwordTextField = CustomPlaceHolderTextField("비밀번호를을 입력하세요")

    let loginBackView = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundPrimary.color
        return view
    }()
    let loginButton = CustomBackgroundTitleButton(title: "로그인", color: Colors.brandInactive.color)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func setHierarchy() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(loginBackView)
        loginBackView.addSubview(loginButton)
        
    }
    
    override func setConstraint() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        loginBackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(68)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "이메일 로그인"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
