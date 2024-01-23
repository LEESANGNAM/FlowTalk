//
//  WorkspaceListEmptyView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/23/24.
//

import UIKit

class WorkspaceListEmptyView: BaseView {
    
    let titleLabel = CustomTitle1BlackLabel(text: "워크스페이스를\n찾을 수 없어요.")
    let subtitleLabel = CustomBodyBlackLabel(text: "관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.")
    let addButton = CustomBackgroundTitleButton(title: "워크스페이스 생성", color: Colors.brandGreen.color)
    
    
    override func setHierarchy() {
        addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        subtitleLabel.numberOfLines = 0
        addSubview(addButton)
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().offset(183)
            make.height.equalTo(60)
            make.width.equalTo(269)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.height.equalTo(75)
            make.width.equalTo(269)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom)
            make.height.equalTo(44)
            make.width.equalTo(269)
            make.bottom.greaterThanOrEqualToSuperview().offset(-258)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    
}
