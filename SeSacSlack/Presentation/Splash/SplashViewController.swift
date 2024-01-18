//
//  SplashViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/18/24.
//

import UIKit

class SplashViewController: BaseViewController {
    let titleLabel = {
        let view = CustomTitle1BlackLabel(text: "새싹톡을 사용하면 어디서나 \n 팀을 모을 수 있습니다.")
        view.numberOfLines = 0
        return view
    }()
    
    let iconImageView = {
        let view = UIImageView()
        view.image = Icon.onboarding.image
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func setHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(iconImageView)
    }
    override func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(39)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(60)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(89)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(13)
            make.height.width.equalTo(368)

        }
    }
    
   
}
