//
//  ResusableProtocol.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/24/24.
//

import Foundation
protocol ResusableProtocol {
    static var identifier: String { get }
}

extension NSObject: ResusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
