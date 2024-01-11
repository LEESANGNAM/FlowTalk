//
//  CustomTitle1BlackLabel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/12/24.
//

import UIKit

class CustomTitle1BlackLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.font = Font.title1.fontWithLineHeight()
        self.text = text
        self.tintColor = Colors.brandBlack.color
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
