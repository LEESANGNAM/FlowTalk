//
//  CoinViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/29/24.
//

import UIKit

class CoinViewController: BaseViewController {
    
    let mainView = CoinView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundSecondar.color
        setNavigationBar()
    }
    
    
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.chevronLeft.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationController?.navigationBar.shadowImage = nil
        navigationItem.title = "코인샵"
        self.navigationController?.navigationBar.barTintColor = Colors.backgroundPrimary.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
