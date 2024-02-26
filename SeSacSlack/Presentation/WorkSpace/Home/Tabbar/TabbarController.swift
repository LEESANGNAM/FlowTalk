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
    let DmVC = DMViewController()
    let searchVC = ChannelSeachViewController()
    let settingVc = SettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [HomeVC,DmVC,searchVC,settingVc]
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
        DmVC.tabBarItem = UITabBarItem(title: "DM", image: Icon.dm.image, tag: 1)
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: Icon.search.image, tag: 2)
        settingVc.tabBarItem = UITabBarItem(title: "설정", image: Icon.setting.image, tag: 3)
    }
    
    
}
