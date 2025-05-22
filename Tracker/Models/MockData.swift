////
////  MockData.swift
////  Tracker
////
////  Created by Matthew on 28.04.2025.
////
//
//import UIKit
//
//final class MockData {
//    let categories: [TrackerCategory]
//    
//    init() {
//        let categoryOne = TrackerCategory(title: "Здоровье", trackers: [MockTrackers.tracker1, MockTrackers.tracker4, MockTrackers.tracker6])
//        let categoryTwo = TrackerCategory(title: "Бизнес", trackers: [MockTrackers.tracker2])
//        let categoryThree = TrackerCategory(title: "Образование", trackers: [MockTrackers.tracker3])
//        let categoryFour = TrackerCategory(title: "Питание", trackers: [MockTrackers.tracker5])
//        
//        self.categories = [categoryOne, categoryTwo, categoryThree, categoryFour]
//    }
//}
//
//fileprivate enum MockTrackers {
//    static let tracker1 = Tracker(
//        title: "5am wake up",
//        color: .brown,
//        emoji: UIImage(named: "Emoji-2")!,
//        schedule: ["Пн", "Ср"]
//    )
//    
//    static let tracker2 = Tracker(
//        title: "Coding",
//        color: .gray,
//        emoji: UIImage(named: "Emoji-3")!,
//        schedule: ["Пн", "Ср"]
//    )
//    
//    static let tracker3 = Tracker(
//        title: "Diploma continue",
//        color: .lightGray,
//        emoji: UIImage(named: "Emoji-4")!,
//        schedule: ["Пн", "Ср"]
//    )
//    
//    static let tracker4 = Tracker(
//        title: "Daily Pull ups",
//        color: .purple,
//        emoji: UIImage(named: "Emoji-7")!,
//        schedule: ["Вт", "Чт"]
//    )
//    
//    static let tracker5 = Tracker(
//        title: "Фруктовый салат",
//        color: .orange,
//        emoji: UIImage(named: "Emoji-9")!,
//        schedule: ["Чт"]
//    )
//    
//    static let tracker6 = Tracker(
//        title: "Gym",
//        color: .systemCyan,
//        emoji: UIImage(named: "Emoji-11")!,
//        schedule: ["Пн", "Ср","Вт", "Чт"]
//    )
//}
