//
//  ChannelChatingViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/2/24.
//

import UIKit

class ChannelChattingViewController: BaseViewController {
    var chatname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.chevronLeft.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = chatname
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
