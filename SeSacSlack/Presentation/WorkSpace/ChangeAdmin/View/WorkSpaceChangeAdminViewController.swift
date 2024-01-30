//
//  WorkSpaceChangeAdminViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/30/24.
//

import UIKit


class WorkSpaceChangeAdminViewController: BaseViewController {
    lazy var tableView = {
        let view = UITableView()
        view.backgroundColor = Colors.backgroundPrimary.color
        view.register(WorkSpaceListTableViewCell.self, forCellReuseIdentifier: WorkSpaceListTableViewCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.bounces = false
        view.delegate = self
        view.dataSource = self
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
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
    
}

extension WorkSpaceChangeAdminViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkSpaceListTableViewCell.identifier, for: indexPath) as? WorkSpaceListTableViewCell else { return UITableViewCell() }
        
        
        return cell
        
    }
    
    
}
