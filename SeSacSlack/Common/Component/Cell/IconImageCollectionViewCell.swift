//
//  ChannelCollectionViewCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/17/24.
//

import UIKit

class IconImageCollectionViewCell: BaseCollectionViewCell {
    let iconImageView = UIImageView()
    
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
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(countButton)
        
    }
    
    override func setConstraint() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.backgroundColor = nil
        iconImageView.tintColor = nil
        iconImageView.image = nil
        titleLabel.text = nil
        countButton.isHidden = true
    }
    
    func setupchnnal(title: String){
        iconImageView.image = Icon.hashtag.image
        titleLabel.text = title
    }
    
    func setupDM(image: UIImage?,title: String){
        if let image {
            iconImageView.image = image
        } else {
            iconImageView.image = UIImage(systemName: "person.fill")
            iconImageView.backgroundColor = Colors.brandGreen.color
            iconImageView.tintColor = Colors.brandWhite.color
        }
        titleLabel.text = title
        iconImageView.layer.cornerRadius = 4
        iconImageView.clipsToBounds = true
        iconImageView.snp.updateConstraints { make in
            make.size.equalTo(22)
        }
    }
    
    func setupLast(title: String) {
        iconImageView.backgroundColor = nil
        iconImageView.tintColor = nil
        titleLabel.text = title
        iconImageView.image = Icon.plus.image
        iconImageView.snp.updateConstraints { make in
            make.size.equalTo(18)
        }
    }
    func setupChatCount(_ count: Int?){
        if let count {
            countButton.isHidden = false
            countButton.setTitle("\(count)", for: .normal)
        } else {
            countButton.isHidden = true
        }
    }
    
}
