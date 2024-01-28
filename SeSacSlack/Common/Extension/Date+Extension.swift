//
//  Date+Extension.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/28/24.
//

import Foundation

extension Date {
    func yyMMddFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. MM. dd"
        return dateFormatter.string(from: self)
    }
}
