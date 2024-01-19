//
//  ViewManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/19/24.
//

import UIKit

final class ViewManager {
    
    static let shared = ViewManager()
    
    func changeRootView(_ vc: UIViewController){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func resetRootView() {
        UserDefaultsManager.resetUserDefaults()
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let vc = OnBoardingViewController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    
}
