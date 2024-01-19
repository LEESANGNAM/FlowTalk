//
//  WorkSpaceProfileView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/13/24.
//

import UIKit
import Kingfisher

class WorkSpaceProfileView: BaseView {
    
    let workSpaceButton = {
        let view = UIButton()
        view.setImage(Icon.workspace.image, for: .normal)
        view.backgroundColor = Colors.brandGreen.color
        view.clipsToBounds = true
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
    
//    func setUI() {
//        setWorkspaceIcon()
//        setProfileIcon()
//    }
    
    func setWorkspaceIcon(workspace: SearchWorkSpaceResponseDTO) {
        let urlString = APIKey.baseURL + "/v1" + workspace.thumbnail
        guard let url = URL(string: urlString ) else { return }
        let imageLoadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.token, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        let testSize = CGSize(width: 32 * 3, height: 32 * 3)
        print("이미지 사이즈 : ",testSize)
        let dowunSizeProcessor = DownsamplingImageProcessor(size: testSize) //사이즈만큼 줄이기
        
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
      
        workSpaceButton.kf.setImage(with: resource, for: .normal,options: [
            .processor(dowunSizeProcessor),
            .requestModifier(imageLoadRequest)
        ]) { value in
            switch value {
            case .success(let value):
                print("워크스페이스 이미지 성공")
                self.workSpaceButton.setImage(value.image, for: .normal)
            case .failure(let error):
                print("이미지 실패",error.localizedDescription)
            }
        }
        workSpaceNameLabel.text = workspace.name
    }
    func setProfileIcon() {
        guard let myinfo = MyInfoManager.shared.myinfo,
              let imageBase = myinfo.profileImage else { return }
        let urlString = APIKey.baseURL + "/v1" + imageBase
        guard let url = URL(string: urlString ) else { return }
        let imageLoadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.token, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        let testSize = CGSize(width: profileButton.frame.width * 3, height: profileButton.frame.height * 3)
        let dowunSizeProcessor = DownsamplingImageProcessor(size: testSize) //사이즈만큼 줄이기
        
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
      
        profileButton.kf.setImage(with: resource, for: .normal,options: [
            .processor(dowunSizeProcessor),
            .requestModifier(imageLoadRequest)
        ]){ value in
            switch value {
            case .success(let value):
                print("프로필 이미지 성공")
            case .failure(let error):
                print("이미지 실패",error.localizedDescription)
            }
        }
    }
    
    
}
