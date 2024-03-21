//
//  ChannelChattingView.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/4/24.
//

import UIKit


class ChannelChattingView: BaseView {
    let chattingTableView = {
        let view = UITableView(frame: .zero)
        view.register(ChannelChattingTableViewCell.self, forCellReuseIdentifier: ChannelChattingTableViewCell.identifier)
        view.backgroundColor = Colors.brandWhite.color
        view.keyboardDismissMode = .onDrag
        view.allowsSelection = false
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        
        view.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: -16)
        return view
    }()
    let chattingInputView =  {
       let view = ChattingInputView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    let inputBackView = {
        let view = UIView()
        view.backgroundColor = Colors.brandWhite.color
        return view
    }()
    
    override func setHierarchy() {
        addSubview(chattingTableView)
        addSubview(inputBackView)
        inputBackView.addSubview(chattingInputView)
    }
    
    override func setConstraint() {
        chattingInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
        }
        
        inputBackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        chattingTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(inputBackView.snp.top)
        }
    }
    
    
}
