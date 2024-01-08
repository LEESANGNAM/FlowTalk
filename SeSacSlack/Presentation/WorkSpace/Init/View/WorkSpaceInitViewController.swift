//
//  WorkSpaceInitViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/8/24.
//

import Foundation

class WorkSpaceInitViewController: BaseViewController {
    
    let testLabel = CustomTitle2BlackLabel(text: "출시 준비 완료 워크스페이스 화면")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setHierarchy() {
        view.addSubview(testLabel)
    }
    
    override func setConstraint() {
        testLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
