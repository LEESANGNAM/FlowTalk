//
//  ChannelCollectionViewCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/17/24.
//

import UIKit

class ChannelCollectionViewCell: BaseCollectionViewCell {
    let tagImageView = UIImageView(image: Icon.hashtag.image)
    
    let titleLabel = {
        let view = UILabel()
        view.text = "일반"
        view.textColor = Colors.textSecondary.color
        view.font = Font.body.fontWithLineHeight()
        return view
    }()
    
    let countButton: CustomBackgroundTitleButton = {
        let button = CustomBackgroundTitleButton(title: "99", color: Colors.brandGreen.color)
        // 폰트 크기 조절
        button.titleLabel?.font = Font.caption.fontWithLineHeight()
        return button
    }()
    
    override func setHierarchy() {
        addSubview(tagImageView)
        addSubview(titleLabel)
        addSubview(countButton)
        
    }
    
    override func setConstraint() {
        tagImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(tagImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        countButton.layer.cornerRadius = 8
        countButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(18)
        }
        
    }
    
    
    
}
