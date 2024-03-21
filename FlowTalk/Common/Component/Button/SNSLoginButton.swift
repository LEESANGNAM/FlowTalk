//
//  CustomIconTitleButton.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/5/24.
//

import UIKit

class SNSLoginButton: UIButton {
    
    init(icon: UIImage? = nil, title: String, subtitle: String? = nil, titleColor: UIColor, subtitleColor: UIColor? = nil, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupButton(icon: icon, title: title, subtitle: subtitle, titleColor: titleColor, subtitleColor: subtitleColor, backgroundColor: backgroundColor)
    }
    
    private func setupButton(icon: UIImage? = nil, title: String, subtitle: String? = nil, titleColor: UIColor, subtitleColor: UIColor? = nil, backgroundColor: UIColor) {
        self.setImage(icon, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
            // Title 설정
            let attributedTitle = NSMutableAttributedString(string: title)
            let titleRange = NSRange(location: 0, length: title.count)

            attributedTitle.addAttribute(.foregroundColor, value: titleColor, range: titleRange)

            // Subtitle이 제공된 경우에만 설정
            if let subtitle {
                let attributedSubtitle = NSMutableAttributedString(string: subtitle)
                let subtitleRange = NSRange(location: 0, length: subtitle.count)
                // Subtitle 색상 설정
                if let subtitleColor {
                    attributedSubtitle.addAttribute(.foregroundColor, value: subtitleColor, range: subtitleRange)
                }
                attributedSubtitle.addAttribute(.font, value: Font.title2.fontWithLineHeight(), range: subtitleRange)
                attributedTitle.append(attributedSubtitle)
            }
        attributedTitle.addAttribute(.font, value: Font.title2.fontWithLineHeight(), range: titleRange)
            setAttributedTitle(attributedTitle, for: .normal)
        }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
