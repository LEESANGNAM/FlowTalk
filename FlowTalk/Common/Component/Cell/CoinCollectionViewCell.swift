//
//  CoinCollectionViewCell.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/29/24.
//

import UIKit

class CoinCollectionViewCell: BaseCollectionViewCell {
    let icon = "🌱"
    let titleLabel = CustomFontColorLabel(text: "", font: Font.bodyBold.fontWithLineHeight(), textAlignment: .left)
    let coinCountLabel = {
        let view = CustomFontColorLabel(text: "", font: Font.bodyBold.fontWithLineHeight(), textColor: Colors.brandGreen.color, textAlignment: .left)
        view.isHidden = true
        return view
    }()
    let subTitleLabel = {
        let view = CustomFontColorLabel(text: "코인이란?", font: Font.caption.fontWithLineHeight(), textColor: Colors.textSecondary.color, textAlignment: .right)
        view.isHidden = true
        return view
    }()
    let priceButton = {
        let view = CustomBackgroundTitleButton(title: "", color: Colors.brandGreen.color)
        view.isHidden = true
        return view
    }()
    
    override func setHierarchy() {
        contentView.backgroundColor = Colors.backgroundSecondar.color
        contentView.addSubview(titleLabel)
        contentView.addSubview(coinCountLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(priceButton)
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.verticalEdges.equalToSuperview().inset(13)
        }
        coinCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.verticalEdges.equalToSuperview().inset(13)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(22)
            make.verticalEdges.equalToSuperview().inset(13)
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(28)
            make.width.equalTo(74)
            make.centerY.equalToSuperview()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        coinCountLabel.isHidden = true
        subTitleLabel.isHidden = true
        priceButton.isHidden = true
    }
    
    func showCoinCount(section: Int) {
        if section == 0 {
            coinCountLabel.isHidden = false
            subTitleLabel.isHidden = false
        } else {
            priceButton.isHidden = false
        }
    }
    func setData(data: CoinStoreListResponseDTO) {
        titleLabel.text = icon + data.item
        priceButton.setTitle("₩"+data.amount, for: .normal)
        
    }
    

    
    
}
