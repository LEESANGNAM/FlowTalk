//
//  CoinViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/29/24.
//

import Foundation
import RxSwift
import RxCocoa


class CoinViewModel {
    let disposeBag = DisposeBag()
    
    let coinShopList = BehaviorRelay<[CoinStoreListResponseDTO]>(value: [])
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let coinShopList: BehaviorRelay<[CoinStoreListResponseDTO]>
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.getCoinShopList()
            }.disposed(by: disposeBag)
        
        return Output(coinShopList: coinShopList)
    }
    
    func getCoinShopList() {
        NetWorkManager.shared.request(type: [CoinStoreListResponseDTO].self, api: .coinStoreList)
            .subscribe(with: self) { owner, value in
                owner.coinShopList.accept(value)
            } onError: { owner, error in
                print("코인리스트 에러있음")
            }.disposed(by: disposeBag)
    }
    
    func getcount() -> Int {
        return coinShopList.value.count
    }
    
    func getitem(index: Int) -> CoinStoreListResponseDTO {
        return coinShopList.value[index]
    }
    
    
}
