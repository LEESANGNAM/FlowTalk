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
    
    let viewModel: WorkSpaceListViewModel
    init(viewModel: WorkSpaceListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.alpha.color.withAlphaComponent(0.0)
        
        setGesture()
        setTableView()
        bind()
    }
    
    private func bind() {
        let input = WorkSpaceListViewModel.Input(viewwillApperEvent: self.rx.viewWillAppear.map{ _ in})
        let output = viewModel.transform(input: input)
        
        output.workspaceData
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    owner.mainView.showEmptyView()
                } else {
                    owner.mainView.showTableView()
                    
                }
            }.disposed(by: disposeBag)
        
        WorkSpaceManager.shared.workspace
            .bind(with: self) { owner, _ in
                owner.mainView.tableView.reloadData()
            }.disposed(by: disposeBag)
        
    }
    
    
    private func setGesture() {
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
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}


extension WorkSpaceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getworkspaceCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkSpaceListTableViewCell.identifier, for: indexPath) as? WorkSpaceListTableViewCell  else { return UITableViewCell()}
        let data = viewModel.getworkSpace(index: indexPath.row)
        cell.setData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.getworkSpace(index: indexPath.row)
        print("셀클릭 워크스페이스 정보",data)
        WorkSpaceManager.shared.setID(data.workspace_id)
    }
    
    
}
