//
//  WorkSpaceChangeAdminViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/30/24.
//

import UIKit
import RxSwift
import RxCocoa

class WorkSpaceChangeAdminViewController: BaseViewController {
    lazy var tableView = {
        let view = UITableView()
        view.backgroundColor = Colors.backgroundPrimary.color
        view.register(WorkSpaceChangeAdminTableViewCell.self, forCellReuseIdentifier: WorkSpaceChangeAdminTableViewCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.rowHeight = 60
        view.bounces = false
        return view
    }()
    
    override func setHierarchy() {
        view.addSubview(tableView)
    }
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private let completeSubject = PublishSubject<Void>()
    let viewModel: WorkSpaceChangeAdminViewModel
    let disposeBag = DisposeBag()
    init(viewModel: WorkSpaceChangeAdminViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bind()
    }
    
    
    func bind() {
        let input = WorkSpaceChangeAdminViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            viewDidAppear: self.rx.viewDidAppear.map{ _ in }
        )
        let output = viewModel.transform(input: input)
        
        output.dataArray
            .bind(to: tableView.rx.items(cellIdentifier: WorkSpaceChangeAdminTableViewCell.identifier, cellType: WorkSpaceChangeAdminTableViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                let selectedData = output.dataArray.value[indexPath.row]
                print("선택된 데이터:", selectedData)
                
                owner.showCustomAlert(
                    titleText: "\(selectedData.getName()) 님을 관리자로 지정하시겠습니까?",
                    messageText:
                       """
                       워크스페이스 관리자는 다음과 같은 권한이 있습니다
                       - 워크스페이스 이름 또는 설명 변경
                       - 워크스페이스 삭제
                       - 워크스페이스 멤버 초대
                       """,
                    okTitle: "확인",
                    cancelTitle: "취소") {
                        print("관리자 변경~ 리스트뷰로 전환~")
                        owner.viewModel.changeAdmin(userId: selectedData.user_id)
                    } cancelAction: {
                        print("변경취소")
                        owner.dismiss(animated: true)
                    }
            })
            .disposed(by: disposeBag)
        
        
        output.arrayEmpty
            .bind(with: self) { owner, value in
                if value {
                    owner.showCustomAlert(
                        titleText: "워크스페이스 관리자 변경 불가",
                        messageText: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요",
                        okTitle: "확인") {
                            owner.dismiss(animated: true) {
                                owner.dismiss(animated: true)
                            }
                        }
                }
            }.disposed(by: disposeBag)
        
        output.isSuccess
            .bind(with: self) { owner, value in
                if value {
                    owner.successChangeAdmin()
                }
            }.disposed(by: disposeBag)
        
    }
    
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "워크스페이스 관리자 변경"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //완료 동작
    private func successChangeAdmin() {
        completeSubject.onNext(())
        dismiss(animated: true) {[weak self] in
            self?.dismiss(animated: true)
        }
    }

    // 외부 구독용
    func completeObservable() -> Observable<Void> {
        return completeSubject.asObservable()
    }
    
}

