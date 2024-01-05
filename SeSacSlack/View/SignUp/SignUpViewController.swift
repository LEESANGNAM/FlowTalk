//
//  SignUpViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import Foundation


class SignUpViewController: BaseViewController {
    
    
    private let mainView = SignUpView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
