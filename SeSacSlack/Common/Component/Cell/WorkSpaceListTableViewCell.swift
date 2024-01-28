//
//  WorkSpaceListTableViewCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import UIKit

class WorkSpaceListTableViewCell: BaseTableViewCell {
    
    let backView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    let iconImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = Colors.brandGreen.color
        return view
    }()
    
    let nameLabel = CustomFontColorLabel(text: "워크스페이스 네임", font: Font.bodyBold.fontWithLineHeight(), textColor: Colors.textPrimary.color)
    
    let dateLabel = CustomFontColorLabel(text: "23.02.02", font: Font.body.fontWithLineHeight(), textColor: Colors.textSecondary.color)
    
    let etcButton = {
        let view = UIButton()
        view.setImage(Icon.etc.image, for: .normal)
        view.isHidden = true
        return view
    }()
    
    override func setHierarchy() {
        contentView.addSubview(backView)
        backView.addSubview(iconImageView)
        backView.addSubview(nameLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(etcButton)
        selectionStyle = .none
    }
    
    override func setConstraint() {
        backView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-6)
            make.verticalEdges.equalToSuperview().inset(6)
            make.height.equalTo(60)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.verticalEdges.equalToSuperview().inset(8)
            make.size.equalTo(44)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(etcButton.snp.leading).offset(-18)
            make.height.equalTo(18)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(etcButton.snp.leading).offset(-18)
            make.height.equalTo(18)
        }
        etcButton.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.size.equalTo(20)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    func setData(data: SearchWorkSpacesResponseDTO) {
        let selectWorkSpaceId = WorkSpaceManager.shared.id
        if selectWorkSpaceId == data.workspace_id {
            backView.backgroundColor = Colors.brandGray.color
            etcButton.isHidden = false
        } else {
            backView.backgroundColor = Colors.brandWhite.color
            etcButton.isHidden = true
        }
        
        layoutIfNeeded()
        let date = data.createDate
        let name = data.name
        let urlString = APIKey.baseURL + "/v1" + data.thumbnail
        let size = iconImageView.frame.size
        iconImageView.setImage(with: urlString, frameSize: size, placeHolder: "workspace")
        nameLabel.text = name
        dateLabel.text = date
    }
    
    
    
}
