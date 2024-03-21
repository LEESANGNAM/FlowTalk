//
//  SeachViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/27/24.
//

import Foundation

class ChannelSeachViewController: BaseViewController {
    
    let titleLabel = CustomFontColorLabel(text: "검색화면", font: Font.title1.fontWithLineHeight())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setHierarchy() {
        view.addSubview(titleLabel)
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
