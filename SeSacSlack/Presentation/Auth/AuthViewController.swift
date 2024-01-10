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
    
    let viewModel: AuthViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    private func bind() {
        let input = AuthViewModel.Input(
            appleLoginButtonTap: appleLoginButton.rx.tap,
            kakaoLoginButtonTap: kakaoLoginButton.rx.tap,
            emailLoginButtonTap: emailLoginButton.rx.tap,
            signUpButtonTap: signUpButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.appleLoginButtonTap
            .bind(with: self) { owner, _ in
                print("애플로그인 버튼 탭")
            }.disposed(by: disposeBag)
        
        output.kakaoLoginButtonTap
            .bind(with: self) { owner, _ in
                print("카카오 로그인 버튼 탭")
            }.disposed(by: disposeBag)
        
        output.emailLoginButtonTap
            .bind(with: self) { owner, _ in
                print("이메일 버튼탭")
            }.disposed(by: disposeBag)
        
        output.signUpButtonTap
            .bind(with: self) { owner, _ in
                owner.signUpButtonTapped()
            }.disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { owner, text in
                owner.showToast(message: text)
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
    
    private func changeRootView(){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let vc = WorkSpaceHomeEmptyViewController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
