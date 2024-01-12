//
//  WorkSpaceHomeEmptyViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/10/24.
//

import UIKit

class WorkSpaceHomeEmptyViewController: BaseViewController {
    
    let titleLabel = CustomTitle1BlackLabel(text: "워크 스페이스를 찾을 수 없어요.")
    let subtitleLabel = CustomBodyBlackLabel(text: "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로운 워크 스페이스를 생성해주세요.")
    let logoImageView = UIImageView(image: Icon.workspaceEmpty.image)
    let workspaceCreateButton = CustomBackgroundTitleButton(title: "워크스페이스 생성", color: Colors.brandGreen.color)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func setHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        view.addSubview(logoImageView)
        view.addSubview(workspaceCreateButton)
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(30)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(40)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(logoImageView.snp.width)
        }
        workspaceCreateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
    
    private func setNavigationBar() {
        let closeButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(closeButtonTapped))
        closeButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = closeButtonItem
        navigationItem.title = "시작하기"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func closeButtonTapped() {
        let vc = WorkSpaceHomeEmptyViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
}
