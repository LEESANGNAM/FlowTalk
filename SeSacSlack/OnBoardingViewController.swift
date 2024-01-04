//
//  ViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/2/24.
//

import UIKit
import SnapKit
class OnBoardingViewController: UIViewController {
    let startButton = CustomBackgroundTitleButton(title: "시작하기", color: Colors.brandGreen.color)
    let titleLabel = {
        let view = UILabel()
        view.text = "새싹톡을 사용하면 어디서나 \n 팀을 모을 수 있습니다."
        view.font = Font.title1.fontWithLineHeight()
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    let iconImageView = {
        let view = UIImageView()
        view.image = Icon.onboarding.image
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.brandWhite.color
        setHierarchy()
        setConstraion()
        // Do any additional setup after loading the view.
    }
    private func setHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(iconImageView)
        view.addSubview(startButton)
    }
    private func setConstraion() {
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
        startButton.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(153)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
    }

}

