//
//  WorkSpaceHomeEmptyViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import Foundation

class WorkSpaceHomeEmptyViewController: BaseViewController {
    let testLabel = CustomTitle2BlackLabel(text: "워크스페이스를 찾을 수 없습니다.~ 빈화면")
    
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
