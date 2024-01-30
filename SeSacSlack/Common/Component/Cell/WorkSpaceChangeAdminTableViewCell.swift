//
//  WorkSpaceChangeAdminTableViewCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/30/24.
//

import UIKit

class WorkSpaceChangeAdminTableViewCell: BaseTableViewCell {
    
    let profileImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = Colors.brandGreen.color
        return view
    }()
    
    let nicknameLabel = CustomFontColorLabel(text: "유저닉네임", font: Font.bodyBold.fontWithLineHeight(), textColor: Colors.textPrimary.color)
    
    let emailLabel = CustomFontColorLabel(text: "test@example.com", font: Font.body.fontWithLineHeight(), textColor: Colors.textSecondary.color)
    
    override func setHierarchy() {
        contentView.backgroundColor = Colors.backgroundPrimary.color
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(emailLabel)
    }
    
    override func setConstraint() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(11)
            make.trailing.lessThanOrEqualTo(self.safeAreaLayoutGuide).offset(-18)
            make.height.equalTo(18)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(self.safeAreaLayoutGuide).offset(-18)
            make.height.equalTo(18)
        }
    }
    
    func setData(_ data: SearchMembersResponseDTO) {
        let email = data.email
        var nickname = data.nickname
        if nickname.isEmpty{
            let components = email.split(separator: "@")
            nickname = components.first.map(String.init) ?? ""
        }
        nicknameLabel.text = nickname
        emailLabel.text = email
        
        layoutIfNeeded()
        let size = profileImageView.frame.size
        if let profile = data.profileImage {
            let urlString = APIKey.baseURL + "/v1" + profile
            profileImageView.setImage(with: urlString, frameSize: size, placeHolder: "NoPhotoA")
        } else {
            profileImageView.image = Icon.noProfileA.image
        }
    }
    
    
}
