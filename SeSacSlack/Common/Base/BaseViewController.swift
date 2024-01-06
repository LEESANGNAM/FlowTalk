//
//  BaseViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundPrimary.color
        setHierarchy()
        setConstraint()
    }
    func setHierarchy() { }
    func setConstraint() { }
    
}
