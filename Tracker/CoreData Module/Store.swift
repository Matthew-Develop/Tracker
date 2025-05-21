//
//  Store.swift
//  Tracker
//
//  Created by Matthew on 17.05.2025.
//

import UIKit
import CoreData


class Store: NSObject {
    let context: NSManagedObjectContext
    
    enum StoreErrors: Error {
        case trackersFetchFailed
        case newTrackerSaveFailed
        case convertionTrackerFromCoreDataFailed
    }
    
    //MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Public Functions
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let colorHex = trackerCoreData.colorHex,
              let color = UIColor(hex: colorHex),
              let title = trackerCoreData.title,
              let emojiImageAssetName = trackerCoreData.emoji,
              let emoji = UIImage(named: emojiImageAssetName),
              let schedule = trackerCoreData.schedule
        else {
            assertionFailure("ERROR Getting trackerCoreData attributes")
            return nil
        }
        
        let convertedTracker = Tracker(
            title: trackerCoreData.title!,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
        return convertedTracker
    }
    
    func getTrackerCoreData(from tracker: Tracker) -> TrackerCoreData {
        let emojiImageAssetName = tracker.emoji.imageAsset?.value(forKey: "assetName") as? String
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.title = tracker.title
        trackerCoreData.colorHex = tracker.color.toHex()
        trackerCoreData.schedule = tracker.schedule
        trackerCoreData.emoji = emojiImageAssetName
        
        return trackerCoreData
    }
}
