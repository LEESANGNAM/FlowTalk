//
//  ChannelChattingTableView.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/5/24.
//

import UIKit

class ChannelChattingTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.image = Icon.noProfileB.image
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let contentStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.alignment = .leading
        return view
    }() // 스택뷰 따로 잡아야 할듯?
    
    let nameLabel = {
        let view = CustomFontColorLabel(
            text: "테스트 유저",
            font: Font.caption.fontWithLineHeight(),
            textAlignment: .left)
        view.numberOfLines = 1
        return view
    }()
    
    
    let chattingBackView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = Colors.brandInactive.color.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let chattingLabel = {
        let view = CustomFontColorLabel(
            text:"컨퍼런스 사진 공유드려요!",
            font: Font.body.fontWithLineHeight(),
            textAlignment: .left)
        view.numberOfLines = 0
        return view
    }()
    
    let ImageView = {
        let view = ChannelChattingCellImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }() // 따로 빼야할듯
    
    let dateLabel = {
        let view = CustomFontColorLabel(
            text:"08:15 오전",
            font: Font.caption.fontWithLineHeight(),
            textColor: Colors.textSecondary.color,
            textAlignment: .left)
        view.numberOfLines = 2
        return view
    }()
    
    
    override func setHierarchy() {
        contentView.addSubview(profileImageView)
        
        contentView.addSubview(contentStackView)
        contentView.addSubview(nameLabel)
        
        contentStackView.addArrangedSubview(chattingBackView)
        chattingBackView.addSubview(chattingLabel)
        
        contentStackView.addArrangedSubview(ImageView)
        
        contentView.addSubview(dateLabel)
    }
    
    override func setConstraint() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(34)
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(18)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.width.lessThanOrEqualTo(244)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        
        
        chattingLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.centerY.equalToSuperview() // backview center
        }
        
        ImageView.snp.makeConstraints { make in
            make.height.equalTo(162)
            make.width.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.trailing.equalToSuperview().offset(-14)
            make.leading.equalTo(contentStackView.snp.trailing).offset(8)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chattingBackView.isHidden = false
        ImageView.isHidden = false
    }
    func setdata(_ data: ChannelChattingModel ) {
        layoutIfNeeded()
        let files = data.files
        setHeight(count: files.count)
        ImageView.setDataView(images: files)
        
        nameLabel.text = data.username
        
        if let profile = data.userProfileImage {
            profileImageView.setImage(with: profile, frameSize: profileImageView.frame.size, placeHolder: "NoPhotoA")
        } else {
            profileImageView.image = Icon.noProfileA.image
        }
        
        if let chatting = data.content {
            chattingLabel.text = chatting
        } else {
            chattingBackView.isHidden = true
        }
     
        dateLabel.text = data.createdAt.toDate()?.formattedDateStringTodayTime()
    }
    
    private func setHeight(count: Int) {
        ImageView.snp.removeConstraints()
        switch count {
        case 2,3:
            ImageView.snp.remakeConstraints { make in
                make.height.equalTo(80)
                make.width.equalToSuperview()
            }
        case 1,4,5:
            ImageView.snp.makeConstraints { make in
                make.height.equalTo(162)
                make.width.equalToSuperview()
            }
        default:
            ImageView.isHidden = true
        }
    }
    
}
