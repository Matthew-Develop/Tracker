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
        case 1: L10n.ScheduleListVC.DaysOfWeek.Monday.short
        case 2: L10n.ScheduleListVC.DaysOfWeek.Tuesday.short
        case 3: L10n.ScheduleListVC.DaysOfWeek.Wednesday.short
        case 4: L10n.ScheduleListVC.DaysOfWeek.Thursday.short
        case 5: L10n.ScheduleListVC.DaysOfWeek.Friday.short
        case 6: L10n.ScheduleListVC.DaysOfWeek.Saturday.short
        case 7: L10n.ScheduleListVC.DaysOfWeek.Sunday.short
        default: "unknown"
        }
    }
}
