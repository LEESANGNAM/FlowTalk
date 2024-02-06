//
//  ChannelChattingInputImageCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/4/24.
//

import UIKit
import RxSwift
import RxCocoa

class ChannelChattingInputImageCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let fileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let removeButton = {
        let view = UIButton()
        view.setImage(Icon.remove.image, for: .normal)
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setHierarchy() {
        contentView.addSubview(fileImageView)
        contentView.addSubview(removeButton)
    }
    
    override func setConstraint() {
        fileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.bottom.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.trailing.equalToSuperview()
        }
        
    }
    
    
}
