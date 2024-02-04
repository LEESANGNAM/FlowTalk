//
//  ChannelChatingViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/2/24.
//

import UIKit

class ChannelChattingViewController: BaseViewController {
    var chatname = ""
    let mainView = ChannelChattingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        mainView.chattingInputView.plusButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        setTableView()
    }
    @objc func test() {
        mainView.chattingInputView.toggleImageCollectionView()
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.chevronLeft.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationController?.navigationBar.shadowImage = nil
        navigationItem.title = chatname
        self.navigationController?.navigationBar.barTintColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setTableView() {
        mainView.chattingTableView.delegate = self
        mainView.chattingTableView.dataSource = self
    }
}

extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "test")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
