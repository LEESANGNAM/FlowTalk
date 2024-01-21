//
//  Icon.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/4/24.
//

import UIKit

enum Icon: String {
    // loginButtonIcon
    case kakao = "KakaoIcon"
    case apple = "appleIcon"
    case email = "emailIcon"
    
    //tabbar
    case home = "homeIcon"
    case dm = "dmIcon"
    case search = "searchIcon"
    case setting = "settingIcon"
    
    //logoIcon
    case onboarding = "onboarding"
    case launching = "launching"
    case workspaceEmpty = "workspaceEmpty"
    
    //create workspace
    case camera = "camera"
    case workspace = "workspace"
    
    //ETC
    case close = "close"
    case plus = "plus"
    
    case hashtag = "hashtag"
    case selecteHashtag = "selectHashtag"
    
    
    case noProfileA = "NoPhotoA"
    case noProfileB = "NoPhotoB"
    case noProfileC = "NoPhotoC"
    
    
    var image: UIImage {
            return UIImage(named: self.rawValue)!
        }
}
    
