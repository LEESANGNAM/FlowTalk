//
//  CustomTitle2BlackLabel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit

class CustomTitle2BlackLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.font = Font.title2.fontWithLineHeight()
        self.text = text
        self.tintColor = Colors.brandBlack.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
