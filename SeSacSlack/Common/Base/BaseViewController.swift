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
    
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2 - 75, y: self.view.frame.height - 141, width: 175, height: 36))
        
        toastLabel.backgroundColor = Colors.brandGreen.color
        toastLabel.textColor = UIColor.white
        toastLabel.font = Font.body.fontWithLineHeight()
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
