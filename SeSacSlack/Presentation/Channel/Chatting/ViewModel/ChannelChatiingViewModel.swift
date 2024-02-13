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
    var chatname = ""
    private let imageData = BehaviorRelay<[Data]>(value: [])
    private let inputText = BehaviorRelay(value: "")
    private let textViewPlaceHolder = "메세지를 입력하세요"
    let disposeBag = DisposeBag()
    struct Input {
        let chattingTextViewChange: ControlProperty<String>
        let sendButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let imageData: BehaviorRelay<[Data]>
        let hiddenImageCollectionView: BehaviorRelay<Bool>
        let sendValid: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let hiddenImageCollectionView = BehaviorRelay(value: true)
        let sendValid = BehaviorRelay(value: false)
        
        input.chattingTextViewChange
            .bind(with: self) { owner, text in
                owner.inputText.accept(text)
                print("텍스트값 변경됨",text)
            }.disposed(by: disposeBag)
        
        imageData.map { $0.isEmpty }
            .bind(to: hiddenImageCollectionView)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(imageData, inputText)
            .map { data,text in
                print("텍스트 빈값 체크",text.isEmpty)
                print("텍스트 플레이스홀더 체크",text == self.textViewPlaceHolder)
                print("데이터 체크",data.isEmpty)
                print("그래서 결과값",!(text.isEmpty || text == self.textViewPlaceHolder) || !data.isEmpty )
                return !(text.isEmpty || text == self.textViewPlaceHolder) || !data.isEmpty // 비어있으면 false
            }.bind(to: sendValid)
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .bind(with: self) { owner, _ in
                print("채팅 전송!")
            }.disposed(by: disposeBag)
        
        
        return Output(
            imageData: imageData,
            hiddenImageCollectionView: hiddenImageCollectionView,
            sendValid: sendValid
        )
    }
    
}


extension ChannelChatiingViewModel {
    func setImageData(_ data: [Data]) {
        print("이미지 데이터 들어옴",data)
        imageData.accept(data)
    }
    func deleteImageData(index: Int) {
        var imageArray = imageData.value
        imageArray.remove(at: index)
        imageData.accept(imageArray)
    }
    func getPlaceHolder() -> String {
        return textViewPlaceHolder
    }
}
