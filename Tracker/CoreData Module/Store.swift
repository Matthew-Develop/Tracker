//
//  Store.swift
//  Tracker
//
//  Created by Matthew on 17.05.2025.
//

import UIKit
import CoreData

private enum StoreErrors: Error {
    case trackersFetchFailed
    case newTrackerSaveFailed
    case trackerFetchFromIDFailed
    case convertionTrackerFromCoreDataFailed
    case categoriesFetchFailed
    case recordsFetchFailed
}

protocol StoreDelegate: AnyObject {
    func didTrackersUpdate()
}

final class Store: NSObject {
    //MARK: - Public Properties
    let context: NSManagedObjectContext
    weak var storeDelegate: StoreDelegate?
    
    //MARK: - Private Properties
    private lazy var fetchedResultsControllerTrackers: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "trackerID", ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    private lazy var fetchedResultsControllerTrackerCategories: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
//        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    private lazy var fetchedResultsControllerTrackerRecord: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "completedDate", ascending: false)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
//        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()
    
    //MARK: - Stored values
    var trackers: [Tracker] {
        guard let trackers = fetchedResultsControllerTrackers.fetchedObjects
        else {
            assertionFailure(StoreErrors.trackersFetchFailed.localizedDescription)
            return []
        }
        return trackers.compactMap { getTracker(from: $0) }
    }
    var trackerCategories: [TrackerCategory] {
        guard let trackerCategories = fetchedResultsControllerTrackerCategories.fetchedObjects
        else {
            assertionFailure(StoreErrors.categoriesFetchFailed.localizedDescription)
            return []
        }
        return trackerCategories.compactMap { getTrackerCategory(from: $0) }
    }
    var trackerRecords: [TrackerRecord] {
        guard let trackerRecords = fetchedResultsControllerTrackerRecord.fetchedObjects
        else {
            assertionFailure(StoreErrors.recordsFetchFailed.localizedDescription)
            return []
        }
        
        return trackerRecords.compactMap { getTrackerRecord(from: $0)}
    }
    var categoryTitles: [String] {
        trackerCategories.map { $0.title }
    }
    
    //MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    //MARK: - Private Functions
    private func getTracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
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
    
    private func makeTrackerCoreData(from tracker: Tracker) -> TrackerCoreData {
        let emojiImageAssetName = tracker.emoji.imageAsset?.value(forKey: "assetName") as? String
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.colorHex = tracker.color.toHex()
        trackerCoreData.schedule = tracker.schedule.joined(separator: ", ")
        trackerCoreData.emoji = emojiImageAssetName
        
        return trackerCoreData
    }
    
    private func getTrackerCategory(from trackerCategory: TrackerCategoryCoreData) -> TrackerCategory? {
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
    
    private func makeTrackerCategoryCoreData(from trackerCategory: TrackerCategory) -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        
        return trackerCategoryCoreData
    }
    
    private func getTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let date = trackerRecordCoreData.completedDate,
              let id = trackerRecordCoreData.tracker?.trackerID
        else {
            return nil
        }
        
        return TrackerRecord(trackerId: id, completeDate: date)
    }
    
    //MARK: - Public Functions
    func eraseAllData() {
        eraseTrackersData()
        eraseCategoriesData()
        eraseRecordsData()
        
        try? context.save()
    }
}

//MARK: - Trackers
extension Store {
    func addNewTracker(_ tracker: Tracker, to categoryName: String) throws {
        let newTracker = makeTrackerCoreData(from: tracker)
        guard let trackerCategory = getTrackerCategory(from: categoryName)
        else {
            throw StoreErrors.categoriesFetchFailed
        }
        
        newTracker.category = trackerCategory
        
        do {
            try context.save()
        } catch {
            assertionFailure("ERROR: saving new tracker to context")
        }
    }
    
    func getTracker(from trackerId: UUID) -> TrackerCoreData? {
        let trackerIdString = trackerId.description
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        guard let result = try? context.fetch(request) else {
            assertionFailure("ERROR: could not fetch tracker from trackerID: \(StoreErrors.trackerFetchFromIDFailed.localizedDescription)")
            return nil
        }
        
        return result.filter({ $0.trackerID?.description == trackerIdString }).first
    }
    
    func eraseTrackersData() {
        let request = TrackerCoreData.fetchRequest()
        guard let result = try? context.fetch(request) else {
            assertionFailure("Failed to fetch trackers")
            return
        }
        
        for object in result {
            context.delete(object)
        }
    }
}

//MARK: - Trackers NSFetchedResultsController Delegate
extension Store: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        storeDelegate?.didTrackersUpdate()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}

//MARK: - TrackerCategory
extension Store {
    func addNewCategory(with title: String) throws -> TrackerCategoryCoreData {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title
        print("Category created with title: \(String(describing: categoryCoreData.title))")
        
        do {
            try context.save()
        } catch {
            assertionFailure("ERROR: saving new category to context")
        }
        return categoryCoreData
    }
    
    func getTrackerCategory(from categoryName: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = ["title"]
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryName)
        
        guard let result = try? context.fetch(request) else {
            assertionFailure("ERROR: could not fetch category from categoryName: \(StoreErrors.categoriesFetchFailed.localizedDescription)")
            return nil
        }
        
        if result.isEmpty {
            do {
                let categoryCoreData = try addNewCategory(with: categoryName)
                return categoryCoreData
            } catch {
                assertionFailure("ERROR: could not add new category with name: \(categoryName)")
            }
        }
        
        let category = result[0]
        assertionFailure("Fetched category from categoryName, title: \(category.title ?? "not found")")
        return category
    }
    
    func eraseCategoriesData() {
        let request = TrackerCategoryCoreData.fetchRequest()
        guard let result = try? context.fetch(request) else {
            assertionFailure("Failed to fetch categories")
            return
        }
        
        for object in result {
            context.delete(object)
        }
    }
}

//MARK: - TrackerRecord
extension Store {
    func addNewRecord(to trackerId: UUID, at date: Date) {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        guard let tracker = getTracker(from: trackerId) else {
            assertionFailure("ERROR: Could not find tracker with provided ID")
            return
        }
        
        newTrackerRecord.completedDate = date
        newTrackerRecord.tracker = tracker
        
        try? context.save()
    }
    
    func deleteRecord(to trackerId: UUID, at date: Date) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K.%K == %@ AND %K == %@",
                                        #keyPath(TrackerRecordCoreData.tracker), #keyPath(TrackerCoreData.trackerID), trackerId as CVarArg,
                                        #keyPath(TrackerRecordCoreData.completedDate), date as CVarArg
        )
        guard let recordsCoreData = try? context.fetch(request)
        else {
            assertionFailure("ERROR: Could not fetch record to delete")
            return
        }
        
        guard let recordToDelete = recordsCoreData.first else { return }
        context.delete(recordToDelete)
        try? context.save()
    }
    
    func eraseRecordsData() {
        let request = TrackerRecordCoreData.fetchRequest()
        guard let result = try? context.fetch(request) else {
            assertionFailure("Failed to fetch records")
            return
        }
        
        for object in result {
            context.delete(object)
        }
    }
}
