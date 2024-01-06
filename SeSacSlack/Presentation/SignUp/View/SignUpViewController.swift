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
        bind()
    }
    private func bind() {
        let input = SignUpViewModel.Input(
            emailCheckButtonTap: mainView.emailCheckButton.rx.tap,
            emailTextFieldChange: mainView.emailTextField.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        output.emailCheck
            .bind(with: self) { owner, value in
                owner.mainView.emailCheckButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandInactive.color
            }.disposed(by: disposeBag)
        
        
        
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
    
    
    
}
