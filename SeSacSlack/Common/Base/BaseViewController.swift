//
//  BaseViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundPrimary.color
        setHierarchy()
        setConstraint()
    }
    func setHierarchy() { }
    func setConstraint() { }
    
}
