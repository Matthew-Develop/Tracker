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
        case 1: "Пн"
        case 2: "Вт"
        case 3: "Ср"
        case 4: "Чт"
        case 5: "Пт"
        case 6: "Сб"
        case 7: "Вс"
        default: "unknown"
        }
    }
}
