//
//  WorkSpaceListViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/23/24.
//

import UIKit

class WorkSpaceListViewController: BaseViewController {
    
    let mainView = WorkSpaceListView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.alpha.color
        mainView.showEmptyView()
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan(_:)))
        edgePanGesture.edges = .right
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func handleScreenEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        print("제스처 상태 확인",gesture.state)
        if gesture.state == .recognized {
            print("스와이프 제스처")
            dismiss(animated: true)
        }
    }
    
}
