//
//  Icon.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit

enum Icon: String {
    case kakao = "KakaoIcon"
    case apple = "appleIcon"
    case email = "emailIcon"
    
    case home = "homeIcon"
    case dm = "dmIcon"
    case search = "searchIcon"
    case setting = "settingIcon"
    
    case onboarding = "onboarding"
    
    var image: UIImage {
            return UIImage(named: self.rawValue)!
        }
}
    
