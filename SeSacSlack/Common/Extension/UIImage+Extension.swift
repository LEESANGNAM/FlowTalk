//
//  UIImage+Extension.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import UIKit

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let size = self.size

        // 이미지의 비율을 유지하면서 새로운 크기 계산
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?
            CGSize(width: size.width * heightRatio, height: size.height * heightRatio) :
            CGSize(width: size.width * widthRatio, height: size.height * widthRatio)

        // 이미지 그래픽 컨텍스트를 생성하고 크기를 적용하여 그림
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

