//
//  CustomIconTitleButton.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit

class SNSLoginButton: UIButton {
    
    init(title: String, icon: UIImage? = nil, titleColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setImage(icon, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
