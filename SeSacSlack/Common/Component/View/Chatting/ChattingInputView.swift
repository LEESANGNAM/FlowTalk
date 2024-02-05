//
//  ChattingInputView.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/3/24.
//

import UIKit

class ChattingInputView: BaseView {
    
    let plusButton = {
        let view = UIButton()
        view.setImage(Icon.plus.image, for: .normal)
        return view
    }()
    
    let sendButton = {
        let view = UIButton()
        view.setImage(Icon.enabledSend.image, for: .normal)
        return view
    }()
    
    let chattingTextView = {
        let view = UITextView()
        view.backgroundColor = Colors.backgroundPrimary.color
        view.font = Font.body.fontWithLineHeight()
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var ImageCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.ImageCollectionViewLayout())
        view.backgroundColor = Colors.backgroundPrimary.color
        view.register(ChannelChattingInputImageCell.self, forCellWithReuseIdentifier: ChannelChattingInputImageCell.identifier)
        return view
    }()
    
    func ImageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        
        return layout
    }
    
    override func setHierarchy() {
        addSubview(plusButton)
        addSubview(sendButton)
        addSubview(chattingTextView)
        addSubview(ImageCollectionView)
    }
    
    override func setConstraint() {
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-12)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
        
        chattingTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.height.lessThanOrEqualTo(54)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
        
        ImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chattingTextView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(chattingTextView)
            make.height.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
        // 이미지 컬렉션뷰를 처음에는 숨기기
        ImageCollectionView.isHidden = true
    }
    
    func toggleImageCollectionView() {
        if ImageCollectionView.isHidden {
            ImageCollectionView.isHidden = false
            chattingTextView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.leading.equalTo(plusButton.snp.trailing).offset(8)
                make.height.equalTo(50)
                make.trailing.equalTo(sendButton.snp.leading).offset(-8)
                make.bottom.equalTo(ImageCollectionView.snp.top).offset(-8)
            }
            
        } else {
            ImageCollectionView.isHidden = true
            chattingTextView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.leading.equalTo(plusButton.snp.trailing).offset(8)
                make.height.equalTo(50)
                make.trailing.equalTo(sendButton.snp.leading).offset(-8)
                make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
            }
        }
        
        // 레이아웃 업데이트
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
