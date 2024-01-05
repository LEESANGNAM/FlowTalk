//
//  BaseView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.backgroundPrimary.color
        setHierarchy()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setHierarchy() { }
    func setConstraint() { }
    
}
