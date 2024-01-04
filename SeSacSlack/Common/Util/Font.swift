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
    
    var font: UIFont {
        switch self {
        case .title1:
            return .boldSystemFont(ofSize: 22)
        case .title2:
            return .boldSystemFont(ofSize: 14)
        case .bodyBold:
            return .boldSystemFont(ofSize: 13)
        case .body:
            return .systemFont(ofSize: 13)
        case .caption:
            return .systemFont(ofSize: 12)
        }
    }
}

