//
//  Design.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit

enum Colors {
    case brandGreen
    case brandError
    case brandInactive
    case brandBlack
    case brandGray
    case brandWhite
    
    case textPrimary
    case textSecondary
    
    case backgroundPrimary
    case backgroundSecondar
    
    case viewSeperator
    case alpha
    
    var color: UIColor {
        switch self {
        case .brandGreen:
            return  UIColor(hexCode: "#4AC645")
        case .brandError:
            return  UIColor(hexCode: "#E9666B")
        case .brandInactive:
            return  UIColor(hexCode: "#AAAAAA")
        case .brandBlack:
            return  UIColor(hexCode: "#000000")
        case .brandGray:
            return  UIColor(hexCode: "#DDDDDD")
        case .brandWhite, .backgroundSecondar:
            return  UIColor(hexCode: "#FFFFFF")
        case .textPrimary:
            return  UIColor(hexCode: "#1C1C1C")
        case .textSecondary:
            return  UIColor(hexCode: "#606060")
        case .backgroundPrimary:
            return  UIColor(hexCode: "#F6F6F6")
        case .viewSeperator:
            return  UIColor(hexCode: "#ECECEC")
        case .alpha:
            return  UIColor(hexCode: "#00000080", alpha: 0.5)
        }
        
    }
    
    
}
