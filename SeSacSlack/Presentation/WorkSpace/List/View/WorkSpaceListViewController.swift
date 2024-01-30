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
        bind()
    }
    
    private func bind() {
        let input = WorkSpaceListViewModel.Input(
            viewwillApperEvent: self.rx.viewWillAppear.map{ _ in},
            addButtonTapped: mainView.addButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        //select
        mainView.tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                owner.selectCell(to: indexPath)
            })
            .disposed(by: disposeBag)
        
        output.workspaceData
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    owner.mainView.showEmptyView()
                } else {
                    owner.mainView.showTableView()
                    
                }
            }.disposed(by: disposeBag)
        
        output.workspaceData
            .bind(to: mainView.tableView.rx.items(cellIdentifier: WorkSpaceListTableViewCell.identifier, cellType: WorkSpaceListTableViewCell.self)) { _, data, cell in
                cell.setData(data: data)
                cell.etcButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.etcButtonTapped(data: data)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.addButtonTapped
            .bind(with: self) { owner, _ in
                let vc = WorkSpaceEditViewController(
                    viewmodel: WorkSpaceEditViewModel(
                        workSpaceUseCase: DefaultWorkSpaceUseCase(
                            workSpaceRepository: DefaultWorkSpaceRepository()
                        )
                    )
                )
                owner.showPresentView(vc: vc)
            }.disposed(by: disposeBag)
        
        
    }
    
    private func etcButtonTapped(data: SearchWorkSpacesResponseDTO) {
        let isAdmin = data.owner_id == MyInfoManager.shared.myinfo?.user_id
        showActionSheet(isAdmin: isAdmin) {
            self.showEditView(data: data)
        } deleteAction: {
            self.showCustomAlert(titleText: "워크스페이스 삭제", messageText: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.", okTitle: "삭제", cancelTitle: "취소") {
                self.viewModel.deleteWorkSpace(data: data)
            } cancelAction: {
                self.dismiss(animated: true)
            }
        } exitAction: {
            print("나가기")
            if isAdmin {
                self.showCustomAlert(titleText: "워크스페이스 나가기", messageText: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.", okTitle: "확인") {
                    self.dismiss(animated: true)
                }
            } else {
                self.showCustomAlert(titleText: "워크스페이스 나가기", messageText: "정말 이 워크스페이스를 떠나시겠습니까? ", okTitle: "나가기", cancelTitle: "취소") {
                    self.viewModel.exitWorkSpace(data: data)
                } cancelAction: {
                    self.dismiss(animated: true)
                }
            }
        } adminChangeAction: {
            print("관리자변경")
            let vc = WorkSpaceChangeAdminViewController(
                viewModel: WorkSpaceChangeAdminViewModel(
                    workspaceUseCase: DefaultWorkSpaceUseCase(
                        workSpaceRepository: DefaultWorkSpaceRepository()
                    )
                )
            )
            self.showPresentView(vc: vc)
            
        }
    }
}


extension WorkSpaceListViewController {
    
    private func setGesture() {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan(_:)))
        edgePanGesture.edges = .right
        view.addGestureRecognizer(edgePanGesture)
    }
    @objc func handleScreenEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            dismiss(animated: true)
        }
    }
    
    private func selectCell(to indexPath: IndexPath) {
        let data = viewModel.getworkSpace(index: indexPath.row)
        WorkSpaceManager.shared.setID(data.workspace_id)
        dismiss(animated: true)
    }
    
    private func showPresentView(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc )
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
    
    private func showEditView(data: SearchWorkSpacesResponseDTO) {
        let vm = WorkSpaceEditViewModel(
            workSpaceUseCase: DefaultWorkSpaceUseCase(
                workSpaceRepository: DefaultWorkSpaceRepository()
            )
        )
        vm.workspaceData.accept(data)
        vm.setImageData(WorkSpaceManager.shared.imageData)
        let vc = WorkSpaceEditViewController( viewmodel: vm )
        
        vc.completeObservable()
            .bind(with: self) { owner, _ in
                WorkSpaceManager.shared.fetchArray()
                WorkSpaceManager.shared.fetch()
                owner.showToast(message: "워크스페이스가 편집되었습니다.")
            }.disposed(by: vc.disposeBag)
        
        showPresentView(vc: vc)
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
}
