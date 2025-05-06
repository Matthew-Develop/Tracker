//
//  Array+Extension.swift
//  Tracker
//
//  Created by Matthew on 05.05.2025.
//

import Foundation

extension Array {
    func sortedDays() -> [String] {
        let days = [ "Пн" ,"Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        var result: [String] = []
        
        for (_, value) in days.enumerated() {
            if self.contains(where: { $0 as? String == value }) {
                result.append(value)
            }
        }
        return result
    }
}
