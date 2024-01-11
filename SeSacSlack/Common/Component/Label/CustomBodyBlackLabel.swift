//
//  CustomBodyBlackLabel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/12/24.
//

import UIKit

class CustomBodyBlackLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.font = Font.body.fontWithLineHeight()
        self.text = text
        self.tintColor = Colors.brandBlack.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
