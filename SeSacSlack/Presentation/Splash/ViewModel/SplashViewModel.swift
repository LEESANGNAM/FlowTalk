//
//  SplashViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/18/24.
//

import Foundation
import RxSwift
import RxCocoa


class SplashViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let isLogin: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let isLogin = PublishRelay<Bool>()
        
        input.viewWillAppearEvent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { return UserDefaultsManager.isLogin }
            .bind(with: self) { owner, value in
                if value {
                    isLogin.accept(true)
                    MyInfoManager.shared.fetch()
                    WorkSpaceManager.shared.fetchArray()
                } else {
                    isLogin.accept(false)
                }
                
            }.disposed(by: disposeBag)
        
        
        return Output(
            isLogin: isLogin
        )
    }
    
}
