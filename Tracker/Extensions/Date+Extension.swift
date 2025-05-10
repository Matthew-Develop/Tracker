//
//  Date+Extension.swift
//  Tracker
//
//  Created by Matthew on 29.04.2025.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        let calendar = Calendar(identifier: .gregorian)
        guard let number = calendar.dateComponents([.weekday], from: self).weekday else {
            return nil
        }
        let dayNumberOfWeekRU: Int = number - 1
        if dayNumberOfWeekRU == 0 {
            return 7
        }
        
        return dayNumberOfWeekRU
    }
    
    func correctedDate() -> Date? {
        let formattedDate = Date.formatter.string(from: self)
        let correctedDate = Date.formatter.date(from: formattedDate)
        return correctedDate
    }
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
