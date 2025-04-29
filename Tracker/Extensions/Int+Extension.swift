//
//  Int+Extension.swift
//  Tracker
//
//  Created by Matthew on 29.04.2025.
//

import Foundation

extension Int {
    func whatDayOfWeek() -> String {
        switch self {
        case 1:
            return "Пн"
        case 2:
            return "Вт"
        case 3:
            return "Ср"
        case 4:
            return "Чт"
        case 5:
            return "Пт"
        case 6:
            return "Сб"
        case 7:
            return "Вс"
        default:
            return "unknown"
        }
    }
}
