//
//  TabbarController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import UIKit

class TabbarController: UITabBarController {
    let HomeVC =  WorkSpaceHomeDefaultViewController(
            viewModel: WorkSpaceHomeDefaultViewModel(
                dmUseCase: DefaultDMUseCase(
                    dmRepository: DefaultDMRepository()),
                channelUseCase: DefaultChannelUseCase(
                    channelRepository: DefaultChannelRepository())
            )
        )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [HomeVC]
        setupTabbar()
    }
    
    private func setupTabbar(){
        tabBar.tintColor = Colors.brandBlack.color
        tabBar.unselectedItemTintColor = Colors.brandInactive.color
        tabBar.backgroundColor = Colors.backgroundSecondar.color
        setupTabbarItem()
    }
    
    private func setupTabbarItem(){
        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: Icon.home.image, tag: 0)
    }
    
    
}
