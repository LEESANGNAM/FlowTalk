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
    let workSpaceUseCase: WorkSpaceUseCase
    
    init(workSpaceUseCase: WorkSpaceUseCase) {
        self.workSpaceUseCase = workSpaceUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let isLoginWorkspace: Observable<(Bool, Bool)>
    }
    
    func transform(input: Input) -> Output {
        let isLogin = PublishRelay<Bool>()
        let isWorkSpaceEmpty = PublishRelay<Bool>()
        
        input.viewWillAppearEvent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { return UserDefaultsManager.isLogin }
            .bind(with: self) { owner, value in
                if value {
                    isLogin.accept(true)
                    let workspace = owner.workSpaceUseCase.searchWorkSpaces()
                    MyInfoManager().fetch()
                    workspace
                        .subscribe(with: self) { owner, workspace in
                            print("워크스페이스값:",workspace)
                            if workspace.isEmpty {
                                isWorkSpaceEmpty.accept(false)
                            } else {
                                let workspaceID = workspace[0].workspace_id
                                UserDefaultsManager.workSpaceId = workspaceID
                                isWorkSpaceEmpty.accept(true)
                            }
                        } onError: { owner, error in
                            print("워크스페이스 찾기 오류")
                            ViewManager.shared.resetRootView()
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
        
        print("콤바인값 :",combineValue)
        
        return Output(
            isLoginWorkspace: combineValue
        )
    }
    
}
