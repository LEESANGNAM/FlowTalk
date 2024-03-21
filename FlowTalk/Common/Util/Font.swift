//
//  Font.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit

enum Font {
    case title1
    case title2
    case bodyBold
    case body
    case caption
}

extension Font {
    private var size: CGFloat {
        switch self {
        case .title1:
            return 22
        case .title2:
            return 14
        case .bodyBold:
            return 13
        case .body:
            return 13
        case .caption:
            return 12
        }
    }
    private var lineHeight: CGFloat {
        switch self {
        case .title1:
            return 30
        case .title2:
            return 20
        case .bodyBold, .body, .caption:
            return 18
        }
    }
    private var baseFont: UIFont {
            switch self {
            case .title1,.title2,.bodyBold:
                return UIFont(name: "SFPro-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
            case .body,.caption:
                return UIFont(name: "SFPro-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
            }
        }
    
    func fontWithLineHeight() -> UIFont {
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.minimumLineHeight = lineHeight
          paragraphStyle.maximumLineHeight = lineHeight

          let attributes: [NSAttributedString.Key: Any] = [
              .font: baseFont,
              .paragraphStyle: paragraphStyle
          ]
          return baseFont
      }
}

