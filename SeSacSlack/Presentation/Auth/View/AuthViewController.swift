//
//  AuthViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices


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
                owner.appleLogin()
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


extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension AuthViewController: ASAuthorizationControllerDelegate {
    
    private func appleLogin(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // 애플 로그인 실패한 경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Login failed \(error.localizedDescription)")
    }
    
    // 애플 로그인 성공한 경우 -> 메인 페이지로 이동 등...
    // 처음 시도 : 계속, email, fullName 제공
    // 두번째 시도: 로그인 하시겠습니까? email, fullName nil 값으로 온다.
    // 사용자에 대한 정보를 계속 제공해주지 않는다. 최초에만 제공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            guard let token = appleIDCredential.identityToken,
                  let tokenToString = String(data: token,encoding: .utf8) else {
                print("Token Error")
                return
            }
            viewModel.appleToken.onNext(tokenToString)
//
//            print("appleIDCredential----------------------------")
//            print("userIdentifier: ",userIdentifier)
//            print("----------------------------")
//            print("fullName: ",fullName ?? "No fullName")
//            print("----------------------------")
//            print("email: ",email ?? "No Email")
//            print("----------------------------")
//            print("token: ",token)
//            print("----------------------------")
//            print("tokenToString: ",tokenToString)
//            print("----------------------------")
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("passwordCredential----------------------------")
            print("username: ",username)
            print("----------------------------")
            print("password: ",password)
            print("----------------------------")
            
            
        default: break
        }
        
        
    }
}


