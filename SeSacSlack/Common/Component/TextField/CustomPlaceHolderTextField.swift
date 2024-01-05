//
//  CustomPlaceHolderTextField.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit


class CustomPlaceHolderTextField: UITextField {
    
    init(_ placeHolder: String){
        super.init(frame: .zero)
        
        let attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: Font.body.fontWithLineHeight()])
        
        self.attributedPlaceholder = attributedPlaceholder
        self.backgroundColor = Colors.backgroundSecondar.color
        self.layer.cornerRadius = 8
        setLeftPadding()
        
    }
    
    private func setLeftPadding() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

