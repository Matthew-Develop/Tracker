//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Matthew on 21.05.2025.
//

import UIKit
import CoreData

final class TrackerRecordStore: Store {
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
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
    
    //MARK: - Stored TrackerRecords
    var trackerRecords: [TrackerRecord] {
        guard let trackerRecords = fetchedResultsController.fetchedObjects
        else {
            assertionFailure(StoreErrors.trackersFetchFailed.localizedDescription)
            return []
        }
        
        var convertedTrackerRecords: [TrackerRecord] = []
        
        for record in trackerRecords {
            guard let convertedRecord = getTrackerRecord(from: record) else { return [] }
            convertedTrackerRecords.append(convertedRecord)
        }
        
        return convertedTrackerRecords
    }
    
    //MARK: - Public Functions
    func addNewRecord(to trackerId: UUID, at date: Date) {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        guard let tracker = TrackerStore().getTracker(from: trackerId) else {
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

        context.delete(recordsCoreData[0])
        try? context.save()
    }
    
    func eraseAllData() {
        let request = TrackerRecordCoreData.fetchRequest()
        let result = try! context.fetch(request)
        
        for object in result {
            context.delete(object)
        }
        try! context.save()
    }
}

//MARK: - NSFetchedResultController Delegate
//extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
//    
//}
