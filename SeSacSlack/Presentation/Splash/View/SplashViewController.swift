//
//  SplashViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/18/24.
//

import UIKit
import RxSwift
import RxCocoa

class SplashViewController: BaseViewController {
    let titleLabel = {
        let view = CustomFontColorLabel(text: "새싹톡을 사용하면 어디서나 \n 팀을 모을 수 있습니다.", font: Font.title1.fontWithLineHeight())
        view.numberOfLines = 0
        return view
    }()
    
    let iconImageView = {
        let view = UIImageView()
        view.image = Icon.onboarding.image
        return view
    }()
    
    let viewModel: SplashViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    private func bind() {
        let input = SplashViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear.map{ _ in })
        
        let output = viewModel.transform(input: input)
        
        output.isLoginWorkspace
            .bind(with: self) { owner, value in
                print("콤바인값 :",value)
                let isLogin = value.0
                let isworkspace = value.1
                
                if isLogin && isworkspace {
                    print("워크스페이스 디폴트로 이동")
                    ViewManager.shared.changeRootView(
                        TabbarController()
                    )
                } else if isLogin && !isworkspace {
                    print("워크스페이스 empty로 이동")
                    ViewManager.shared.changeRootView(WorkSpaceHomeEmptyViewController())
                } else {
                    print("온보딩 뷰로 이동")
                    ViewManager.shared.changeRootView(OnBoardingViewController())
                }
            }.disposed(by: disposeBag)
        
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
