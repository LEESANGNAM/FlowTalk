//
//  WorkSpaceProfileView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/13/24.
//

import UIKit
import Kingfisher

class WorkSpaceProfileView: BaseView {
    
    let workSpaceImageView = {
        let view = UIImageView()
        view.backgroundColor = Colors.brandGreen.color
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let profileImageView = {
        let view = UIImageView()
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
        addSubview(workSpaceImageView)
        addSubview(profileImageView)
        addSubview(workSpaceNameLabel)
    }
    
    override func setConstraint() {
        workSpaceImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        workSpaceNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(workSpaceImageView.snp.trailing).offset(8)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    
    func setWorkspaceIcon(workspace: SearchWorkSpaceResponseDTO? = nil) {
        if let workspace {
            let urlString = APIKey.baseURL + "/v1" + workspace.thumbnail
            let imageSize = workSpaceImageView.frame.size
            workSpaceImageView.setImage(with: urlString, frameSize: imageSize, placeHolder: "dmIcon")
            workSpaceNameLabel.text = workspace.name
        } else {
            workSpaceImageView.image = Icon.workspace.image
            workSpaceNameLabel.text = "No WorkSpace"
        }
        
    }
    func setProfileIcon() {
        if let myinfo = MyInfoManager.shared.myinfo,
           let imageBase = myinfo.profileImage {
            let urlString = APIKey.baseURL + "/v1" + imageBase
            let imageSize = profileImageView.frame.size
            profileImageView.setImage(with: urlString, frameSize: imageSize, placeHolder: "person.fill")
        } else {
            profileImageView.image = Icon.noProfileB.image
        }
    }
    
    
}
