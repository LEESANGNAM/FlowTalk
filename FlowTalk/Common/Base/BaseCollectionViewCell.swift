//
//  BaseCollectionViewCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/17/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setHierarchy(){ }
    func setConstraint(){ }
    
    
}
