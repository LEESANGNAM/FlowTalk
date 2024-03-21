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
    
    func toAPIString() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           return dateFormatter.string(from: self)
       }
    
    func formattedDateStringTodayTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let isToday = Calendar.current.isDateInToday(self)
        
        if isToday {
            // 오늘이면 시간
            dateFormatter.dateFormat = "hh:mm a"
        } else {
            // 오늘이 아니면 날짜와 시간
            dateFormatter.dateFormat = "M/d\nhh:mm a"
        }
        return dateFormatter.string(from: self)
    }
}
