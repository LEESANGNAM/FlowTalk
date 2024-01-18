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
        let viewdidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let isLoginWorkspace: Observable<(Bool, Bool)>
    }
    
    func transform(input: Input) -> Output {
        let isLogin = PublishRelay<Bool>()
        let isWorkSpaceEmpty = PublishRelay<Bool>()
        
        input.viewdidLoadEvent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { return UserDefaultsManager.isLogin }
            .bind(with: self) { owner, value in
                if value {
                    isLogin.accept(true)
                    NetWorkManager.shared.request(type: [SearchWorkSpacesResponseDTO].self, api: .searchWorkSpaces)
                        .subscribe(with: self) { owner, workspace in
                            print("워크스페이스값:",workspace)
                            if workspace.isEmpty {
                                isWorkSpaceEmpty.accept(false)
                            } else {
                                isWorkSpaceEmpty.accept(true)
                            }
                        } onError: { owner, error in
                            print("워크스페이스 찾기 오류")
                        } onCompleted: { _ in
                            print("워크 스페이스 찾기 완료")
                        } onDisposed: { _ in
                            print("워크 스페이스 찾기 디스포즈")
                        }.disposed(by: owner.disposeBag)
                } else {
                    isLogin.accept(false)
                    isWorkSpaceEmpty.accept(false)
                }
            }.disposed(by: disposeBag)
        
        let combineValue = Observable.combineLatest(isLogin, isWorkSpaceEmpty)

        
        return Output(
            isLoginWorkspace: combineValue
        )
    }
    
}
