//
//  SignUpViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    
    private let mainView = SignUpView()
    private let viewModel: SignUpViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setDelegate()
        bind()
    }
    private func bind() {
        let input = SignUpViewModel.Input(
            emailCheckButtonTap: mainView.emailCheckButton.rx.tap,
            emailTextFieldChange: mainView.emailTextField.rx.text.orEmpty,
            nicknameTextFieldChange: mainView.nicknameTextField.rx.text.orEmpty,
            phoneNumTextFieldChange: mainView.phoneNumTextField.rx.text.orEmpty,
            passwordTextFieldChange: mainView.passwordTextField.rx.text.orEmpty,
            passwordCheckTextFieldChange: mainView.passwordCheckTextField.rx.text.orEmpty,
            signupButtonTap: mainView.signUpButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.emailValid
            .bind(with: self) { owner, value in
                owner.mainView.emailCheckButton.isEnabled = value
                owner.mainView.emailCheckButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandInactive.color
            }.disposed(by: disposeBag)
        
        output.textFieldFill
            .bind(with: self) { owner, value in
                owner.mainView.signUpButton.isEnabled = value
                owner.mainView.signUpButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandInactive.color
            }.disposed(by: disposeBag)
        
        output.phoneText
            .bind(to: mainView.phoneNumTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.nicknameCheck
            .map { $0 ? Colors.brandBlack.color : Colors.brandError.color }
            .bind(to: mainView.nicknameLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.phoneNumCheck
            .map { $0 ? Colors.brandBlack.color : Colors.brandError.color }
            .bind(to: mainView.phoneNumLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.passwordCheck
            .map {$0 ? Colors.brandBlack.color : Colors.brandError.color }
            .bind(to: mainView.passwordLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.confirmPasswordCheck
            .map { $0 ? Colors.brandBlack.color : Colors.brandError.color }
            .bind(to: mainView.passwordCheckLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.message
            .bind(with: self) { owner, errorText in
                owner.showToast(message: errorText)
            }.disposed(by: disposeBag)
        
        output.errorTextfield
            .bind(with: self) { owner, errorTextField in
                switch errorTextField {
                case .emailTextField:
                    owner.mainView.emailTextField.becomeFirstResponder()
                case .nicknameTextField:
                    owner.mainView.nicknameLabel.becomeFirstResponder()
                case .phoneNumTextField:
                    owner.mainView.phoneNumTextField.becomeFirstResponder()
                case .passwordTextField:
                    owner.mainView.passwordTextField.becomeFirstResponder()
                case .passwordCheckTextField:
                    owner.mainView.passwordCheckTextField.becomeFirstResponder()
                }
            }
        
    }
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        print("뒤로가기 버튼 탭")
        
        if let presentingViewController = self.presentingViewController?.presentingViewController {
                presentingViewController.dismiss(animated: true, completion: nil)
            }

    }
    private func setDelegate() {
        mainView.emailTextField.delegate = self
        mainView.nicknameTextField.delegate = self
        mainView.phoneNumTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.passwordCheckTextField.delegate = self
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            switch textField {
            case mainView.emailTextField:
                mainView.nicknameTextField.becomeFirstResponder()
            case mainView.nicknameTextField:
                mainView.phoneNumTextField.becomeFirstResponder()
            case mainView.phoneNumTextField:
                mainView.passwordTextField.becomeFirstResponder()
            case mainView.passwordTextField:
                mainView.passwordCheckTextField.becomeFirstResponder()
            case mainView.passwordCheckTextField:
                mainView.passwordCheckTextField.resignFirstResponder()
            default:
                textField.resignFirstResponder()
            }
            return true
        }
}

