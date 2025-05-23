//
//  Store.swift
//  Tracker
//
//  Created by Matthew on 17.05.2025.
//

import UIKit
import CoreData

enum StoreErrors: Error {
    case trackersFetchFailed
    case newTrackerSaveFailed
    case trackerFetchFromIDFailed
    case convertionTrackerFromCoreDataFailed
    case categoriesFetchFailed
}

class Store: NSObject {
    let context: NSManagedObjectContext
    
    //MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    //MARK: - Public Functions
    func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.trackerID,
              let colorHex = trackerCoreData.colorHex,
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
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule.components(separatedBy: ", ")
        )
        return convertedTracker
    }
    
    func getTrackerCoreData(from tracker: Tracker) -> TrackerCoreData {
        let emojiImageAssetName = tracker.emoji.imageAsset?.value(forKey: "assetName") as? String
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.colorHex = tracker.color.toHex()
        trackerCoreData.schedule = tracker.schedule.joined(separator: ", ")
        trackerCoreData.emoji = emojiImageAssetName
        
        return trackerCoreData
    }
    
    func getTrackerCategory(from trackerCategory: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = trackerCategory.title,
              let trackers = trackerCategory.trackers
        else {
            return nil
        }
        
        var convertedTrackers: [Tracker] = []
        for tracker in trackers {
            guard let trackerCoreData = tracker as? TrackerCoreData,
                  let convertedTracker = getTracker(from: trackerCoreData)
            else {
                return nil
            }
            convertedTrackers.append(convertedTracker)
        }
        return TrackerCategory(title: title, trackers: convertedTrackers)
    }
    
    func getTrackerCategoryCoreData(from trackerCategory: TrackerCategory) -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        
        return trackerCategoryCoreData
    }
    
    func getTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let date = trackerRecordCoreData.completedDate,
              let id = trackerRecordCoreData.tracker?.trackerID
        else {
            return nil
        }
        
        return TrackerRecord(trackerId: id, completeDate: date)
    }
}
