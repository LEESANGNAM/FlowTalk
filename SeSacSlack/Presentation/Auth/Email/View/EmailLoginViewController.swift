//
//  EmailLoginViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    
    let viewModel: EmailLoginViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: EmailLoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setDelegate()
        bind()
    }
    
    private func bind() {
        let input = EmailLoginViewModel.Input(
            emailTextFieldChange: emailTextField.rx.text.orEmpty,
            passwordTextFieldChange: passwordTextField.rx.text.orEmpty,
            loginButtonTapped: loginButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
    
        output.textFieldFill
            .bind(with: self) { owner, value in
                owner.loginButton.isEnabled = value
                owner.loginButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandInactive.color
            }.disposed(by: disposeBag)
        
        output.emailCheck
            .map { $0 ? Colors.brandBlack.color : Colors.brandError.color }
            .bind(to: emailLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.passwordCheck
            .map { $0 ? Colors.brandBlack.color : Colors.brandError.color }
            .bind(to: passwordLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        
        output.message
            .bind(with: self) { owner, errorText in
                owner.showToast(message: errorText)
            }.disposed(by: disposeBag)
        
        output.errorTextfield
            .bind(with: self) { owner, errorTextField in
                switch errorTextField {
                case .emailTextField:
                    owner.emailTextField.becomeFirstResponder()
                case .passwordTextField:
                    owner.passwordTextField.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)
        
        output.isSuccess
            .bind(with: self) { owner, result in
                if result {
                    print("로그인 성공 home Default 이동")
                    owner.changeRootView()
                } else {
                    print("가만히 있기")
                }
            }.disposed(by: disposeBag)
        
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
    private func setDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func changeRootView(){
        var testModel: [SearchWorkSpacesResponseDTO]!
        
        NetWorkManager.shared.request(type: [SearchWorkSpacesResponseDTO].self, api: .searchWorkSpaces)
            .subscribe(with: self) { owner, value in
                print("워크스페이스 확인 ",value)
                testModel = value
            } onError: { owner, error in
                print("워크스페이스 에러:",error)
            } onCompleted: { _ in
                print("워크스페이스 찾기 완료")
        
                if testModel.isEmpty {
                    ViewManager.shared.changeRootView(WorkSpaceHomeEmptyViewController())
                } else {
                    let workspaceID = testModel[0].workspace_id
                    WorkSpaceManager.shared.setID(workspaceID)
                    ViewManager.shared.changeRootView(WorkSpaceHomeInitViewController())
                }
                
            } onDisposed: { _ in
                print("워크스페이스 찾기 디스포즈")
            }.disposed(by: disposeBag)
        
        
    }
}


extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                passwordTextField.resignFirstResponder()
            default:
                textField.resignFirstResponder()
            }
            return true
        }
}
