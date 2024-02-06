//
//  ChannelChatiingViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class ChannelChatiingViewModel {
    
    private let imageData = BehaviorRelay<[Data]>(value: [])
    private let inputText = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    struct Input {
        let chattingTextViewChange: ControlProperty<String>
    }
    
    struct Output {
        let imageData: BehaviorRelay<[Data]>
        let hiddenImageCollectionView: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let hiddenImageCollectionView = BehaviorRelay(value: true)
        
        input.chattingTextViewChange
            .bind(with: self) { owner, text in
                owner.inputText.accept(text)
            }.disposed(by: DisposeBag())
        
        imageData.map { $0.isEmpty }
            .bind(to: hiddenImageCollectionView)
            .disposed(by: disposeBag)
        
        return Output(
            imageData: imageData,
            hiddenImageCollectionView: hiddenImageCollectionView
        )
    }
    
}


extension ChannelChatiingViewModel {
    func setImageData(_ data: [Data]) {
        print("이미지 데이터 들어옴",data)
        imageData.accept(data)
    }
}
