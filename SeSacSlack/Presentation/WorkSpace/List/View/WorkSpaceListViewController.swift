//
//  WorkSpaceListViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class WorkSpaceListViewController: BaseViewController {
    
    let mainView = WorkSpaceListView()
    let disposeBag = DisposeBag()
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.alpha.color
        
        WorkSpaceManager.shared.workspace
            .bind(with: self) { owner, workspace in
                if let workspace {
                    owner.mainView.showTableView()
                    owner.mainView.tableView.backgroundColor = .systemBlue
                } else {
                    owner.mainView.showEmptyView()
                }
            }
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan(_:)))
        edgePanGesture.edges = .right
        view.addGestureRecognizer(edgePanGesture)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    @objc func handleScreenEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        print("제스처 상태 확인",gesture.state)
        if gesture.state == .recognized {
            print("스와이프 제스처")
            dismiss(animated: true)
        }
    }
    
}


extension WorkSpaceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Test")
        cell.textLabel?.text = "테스트"
        return cell
    }
    
    
}
