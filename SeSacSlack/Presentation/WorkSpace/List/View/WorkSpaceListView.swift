//
//  WorkSpaceListView.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/23/24.
//

import UIKit

class WorkSpaceListView: BaseView {
    
    let containerView = {
        let view = UIView()
        view.backgroundColor = Colors.brandWhite.color
        view.roundCorners(cornerRadius: 25, maskedCorners: [.layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        return view
    }()
    
    let navibarTitle = CustomTitle1BlackLabel(text: "워크스페이스")
    let navibar = {
        let view = UIView()
        view.backgroundColor = Colors.backgroundPrimary.color
        return view
    }()
    
    let emptyView = {
        let view = WorkspaceListEmptyView()
        view.isHidden = true
        view.backgroundColor = Colors.brandWhite.color
        return view
    }()
    
    let tableView = {
        let view = UITableView()
        view.isHidden = true
        view.backgroundColor = Colors.brandWhite.color
        view.register(WorkSpaceListTableViewCell.self, forCellReuseIdentifier: WorkSpaceListTableViewCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.bounces = false
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = Icon.plus.image
        configuration.baseForegroundColor = Colors.textSecondary.color
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        configuration.imagePadding = 16
        var attributedText = AttributedString("워크스페이스 추가")
        attributedText.font = Font.body.fontWithLineHeight()
        attributedText.foregroundColor = Colors.textSecondary.color
        configuration.attributedTitle = attributedText
        view.configuration = configuration
        return view
    }()
    
    let helpButton = {
        let view = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = Icon.help.image
        configuration.baseForegroundColor = Colors.textSecondary.color
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        configuration.imagePadding = 16
        var attributedText = AttributedString("도움말")
        attributedText.font = Font.body.fontWithLineHeight()
        attributedText.foregroundColor = Colors.textSecondary.color
        configuration.attributedTitle = attributedText
        view.configuration = configuration
        return view
    }()
    
    override func setHierarchy() {
        addSubview(containerView)
        containerView.addSubview(navibar)
        navibar.addSubview(navibarTitle)
        
        containerView.addSubview(helpButton)
        containerView.addSubview(addButton)
        
        containerView.addSubview(emptyView)
        containerView.addSubview(tableView)
        
        
        
        
    }
    
    override func setConstraint() {
        
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().multipliedBy(0.8)
        }
        
        navibar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(98)
        }
        navibarTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(51)
            make.bottom.equalToSuperview().offset(-17)
            make.height.equalTo(30)
        }
        
        helpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-33)
            make.leading.equalToSuperview()
            make.height.equalTo(41)
        }
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(helpButton.snp.top)
            make.leading.equalToSuperview()
            make.height.equalTo(41)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.bottom.equalTo(addButton.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.bottom.equalTo(addButton.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    
    func showEmptyView() {
        emptyView.isHidden = false
        tableView.isHidden = true
    }
    
    func showTableView() {
        emptyView.isHidden = true
        tableView.isHidden = false
    }
}


