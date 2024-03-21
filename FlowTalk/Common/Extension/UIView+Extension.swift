//
//  UIView+Extension.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import UIKit

extension UIView {
    // 코너 지정
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
            layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
        }
}
