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
    
    private func showActionSheet(isAdmin: Bool, editAction: @escaping () -> Void, deleteAction: @escaping () -> Void,exitAction: @escaping () -> Void , adminChangeAction: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var actionArray: [UIAlertAction] = []
        // 관리자일 경우에만 추가 액션들을 추가
        if isAdmin {
            let editAction = UIAlertAction(title: "워크스페이스 편집", style: .default) { _ in
                editAction()
            }
            let exitAction = UIAlertAction(title: "워크스페이스 나가기", style: .default) { _ in
                exitAction()
            }
            let adminChangeAction = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { _ in
                adminChangeAction()
            }
            let deleteAction = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { _ in
                deleteAction()
            }
            actionArray.append(contentsOf: [editAction,exitAction,adminChangeAction,deleteAction])
        } else {
            let exitAction = UIAlertAction(title: "나가기", style: .default) { _ in
                exitAction()
            }
            actionArray.append(exitAction)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionArray.append(cancelAction)
        
        actionArray.forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true)
    }
    
    @objc func cellETCButtonTapped(_ sender: UIButton) {
        let data = viewModel.getworkSpace(index: sender.tag)
        let isAdmin = data.owner_id == MyInfoManager.shared.myinfo?.user_id
        showActionSheet(isAdmin: isAdmin) {
            print("편집")
        } deleteAction: {
            print("삭제")
        } exitAction: {
            print("나가기")
            if isAdmin {
                print("관리자임 못나감")
            } else {
                NetWorkManager.shared.request(type: [ExitWorkSpaceResponseDTO].self, api: .exitWorkSpace(ExitWorkSpaceRequestDTO(id: data.workspace_id)))
                    .subscribe(with: self) { owner, value in
                        print("퇴장성공함, 남은데이터: ",value)
                    } onError: { _, error in
                        print("에러가 있을거임")
                    } onCompleted: { _ in
                        print("퇴장완료")
                    } onDisposed: { _ in
                        print("디스포즈")
                    }.disposed(by: self.disposeBag)
            }
        } adminChangeAction: {
            print("관리자변경")
        }

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
        cell.etcButton.tag = indexPath.row
        cell.etcButton.addTarget(self, action: #selector(cellETCButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.getworkSpace(index: indexPath.row)
        print("셀클릭 워크스페이스 정보",data)
        WorkSpaceManager.shared.setID(data.workspace_id)
    }
    
    
}
