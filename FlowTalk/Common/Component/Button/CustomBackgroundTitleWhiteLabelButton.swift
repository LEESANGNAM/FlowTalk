//
//  CustomBackgroundTitleButton.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit


class CustomBackgroundTitleButton: UIButton {
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = color
        self.setTitleColor(Colors.brandWhite.color, for: .normal)
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
