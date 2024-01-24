//
//  CustomFontColorLabel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import UIKit

class CustomFontColorLabel: UILabel {
    
    init(text: String, font: UIFont, textColor: UIColor? = Colors.brandBlack.color ) {
        super.init(frame: .zero)
        self.font = font
        self.text = text
        self.textColor = textColor
        self.textAlignment = .center
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
