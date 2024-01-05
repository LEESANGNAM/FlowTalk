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
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        test()
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
    
    func test() {
        mainView.emailCheckButton.addTarget(self, action: #selector(emailCheckButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func emailCheckButtonTapped() {
        if let text = mainView.emailTextField.text {
            let requstmodel = EmailValidationRequestDTO(email: text)
            print("텍스트",text)
            print("보내는모델",requstmodel)
            let test =  NetWorkManager.shared.request(type: EmptyResponseDTO.self, api: .emailValid(requstmodel))
            
            test.subscribe(with: self) { owner, value in
                print("값 가져옴")
                print(value)
            } onError: { owner, error in
                print("에러임")
                print(error)
                if let networkError = error as? NetWorkErrorType {
                    print("커스텀 에러임")
                    print(networkError.message)
                }
            } onCompleted: { _ in
                print("이메일 체크 완료")
            } onDisposed: { _ in
                print("이메일 체크 디스포즈")
            }.disposed(by: disposeBag)

        }
        
        
    }
    
    
}
