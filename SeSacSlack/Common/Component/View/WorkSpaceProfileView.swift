//
//  WorkSpaceProfileView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/13/24.
//

import UIKit

class WorkSpaceProfileView: BaseView {
    
    let workSpaceButton = {
        let view = UIButton()
        view.setImage(Icon.workspace.image, for: .normal)
        view.backgroundColor = Colors.brandGreen.color
        view.layer.cornerRadius = 8
        return view
    }()
    
    let profileButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "person.fill"), for: .normal)
        view.backgroundColor = Colors.brandGray.color
        view.tintColor = Colors.brandWhite.color
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    let workSpaceNameLabel = {
        let view = CustomTitle1BlackLabel(text: "No WorkSpace")
        view.textAlignment = .left
        return view
    }()
    
    override func setHierarchy() {
        addSubview(workSpaceButton)
        addSubview(profileButton)
        addSubview(workSpaceNameLabel)
    }
    
    override func setConstraint() {
        workSpaceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        profileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        workSpaceNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(workSpaceButton.snp.trailing).offset(8)
            make.trailing.equalTo(profileButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
}
