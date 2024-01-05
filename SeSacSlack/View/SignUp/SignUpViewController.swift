//
//  SignUpViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit


class SignUpViewController: BaseViewController {
    
    
    private let mainView = SignUpView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
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
