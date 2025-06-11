//
//  Array+Extension.swift
//  Tracker
//
//  Created by Matthew on 05.05.2025.
//

import Foundation

extension Array {
    func sortedDays() -> [String] {
        let days = [
            L10n.ScheduleListVC.DaysOfWeek.Monday.short,
            L10n.ScheduleListVC.DaysOfWeek.Tuesday.short,
            L10n.ScheduleListVC.DaysOfWeek.Wednesday.short,
            L10n.ScheduleListVC.DaysOfWeek.Thursday.short,
            L10n.ScheduleListVC.DaysOfWeek.Friday.short,
            L10n.ScheduleListVC.DaysOfWeek.Saturday.short,
            L10n.ScheduleListVC.DaysOfWeek.Sunday.short
        ]
        var result: [String] = []
        
        for (_, value) in days.enumerated() {
            if self.contains(where: { $0 as? String == value }) {
                result.append(value)
            }
        }
        return result
    }
}
