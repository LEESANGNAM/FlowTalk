//
//  ChannelChattingCellImageView.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/5/24.
//

import UIKit

class ChannelChattingCellImageView: BaseView {
    // 이미지 5개잡고
    // 함수로 레이아웃 다시잡기
    
    static func createImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.contentMode = .scaleAspectFill
        return view
    }
    
    let imageView1 = createImageView()
    let imageView2 = createImageView()
    let imageView3 = createImageView()
    let imageView4 = createImageView()
    let imageView5 = createImageView()
    
    lazy var imageViewArray = [
        imageView1,
        imageView2,
        imageView3,
        imageView4,
        imageView5
    ]
    
    override func setHierarchy() {
        imageViewArray.forEach { addSubview($0)}
        imageViewArray[0].backgroundColor = .systemBlue
        imageViewArray[1].backgroundColor = .systemOrange
        imageViewArray[2].backgroundColor = .systemRed
        imageViewArray[3].backgroundColor = .systemYellow
        imageViewArray[4].backgroundColor = .systemBrown
    }
    
}

extension ChannelChattingCellImageView {
    func setDataView(images: [String]) {
        
        
        
        imageViewArray.forEach { $0.snp.removeConstraints() }
        
        switch images.count {
        case 1: set1Layout()
        case 2: set2Layout()
        case 3: set3Layout()
        case 4: set4Layout()
        case 5: set5Layout()
        default: return
        }
        
        for i in 0..<images.count {
            imageViewArray[i].setImage(with: images[i], frameSize: CGSize(width: 300, height: 300), placeHolder: "close")
        }
    }
    
    
    func set1Layout() {
        for i in 0..<imageViewArray.count {
            if i < 1 {
                imageViewArray[i].isHidden = false
            } else {
                imageViewArray[i].isHidden = true
            }
        }
        
        imageViewArray[0].snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(244)
            make.height.equalTo(162)
        }
    }
    
    func set2Layout() {
        for i in 0..<imageViewArray.count {
            if i < 2 {
                imageViewArray[i].isHidden = false
            } else {
                imageViewArray[i].isHidden = true
            }
        }
        
        imageViewArray[0].snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-1)
//            make.height.equalTo(80)
        }
        imageViewArray[1].snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-1)
//            make.height.equalTo(80)
        }
    }
    func set3Layout() {
        for i in 0..<imageViewArray.count {
            if i < 3 {
                imageViewArray[i].isHidden = false
            } else {
                imageViewArray[i].isHidden = true
            }
        }
        
        imageViewArray[0].snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3).offset(-1)
//            make.height.equalTo(80)
        }
        imageViewArray[1].snp.makeConstraints { make in
            make.leading.equalTo(imageViewArray[0].snp.trailing).offset(2)
            make.width.equalToSuperview().dividedBy(3).offset(-1)
            make.verticalEdges.equalToSuperview()
//            make.height.equalTo(80)
        }
        imageViewArray[2].snp.makeConstraints { make in
            make.leading.equalTo(imageViewArray[1].snp.trailing).offset(2)
            make.width.equalToSuperview().dividedBy(3).offset(-1)
            make.verticalEdges.equalToSuperview()
//            make.height.equalTo(80)
        }
    }
    
    func set4Layout() {
        for i in 0..<imageViewArray.count {
            if i < 4 {
                imageViewArray[i].isHidden = false
            } else {
                imageViewArray[i].isHidden = true
            }
        }
        
        imageViewArray[0].snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }
        imageViewArray[1].snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }
        imageViewArray[2].snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }
        imageViewArray[3].snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }
        
        
    }
    func set5Layout() {
        for i in 0..<imageViewArray.count {
            imageViewArray[i].isHidden = false
        }
        
        imageViewArray[0].snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2).offset(-1)
            make.width.equalToSuperview().dividedBy(3).offset(-1)
        }
        imageViewArray[1].snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageViewArray[0].snp.trailing).offset(2)
            make.height.width.equalTo(imageViewArray[0])
        }
        imageViewArray[2].snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageViewArray[1].snp.trailing).offset(2)
            make.height.width.equalTo(imageViewArray[0])
        }
        imageViewArray[3].snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.height.width.equalToSuperview().dividedBy(2).offset(-1)
        }
        imageViewArray[4].snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.height.width.equalTo(imageViewArray[3])
        }
    }
    
    
}
