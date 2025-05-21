//
//  TrackerStore.swift
//  Tracker
//
//  Created by Matthew on 21.05.2025.
//

import UIKit
import CoreData

final class TrackerStore: Store {
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
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
    
    var trackers: [Tracker] {
        guard let trackers = fetchedResultsController.fetchedObjects
        else {
            assertionFailure(StoreErrors.trackersFetchFailed.localizedDescription)
            return []
        }
        var convertedTrackers: [Tracker] = []
        
        for tracker in trackers {
            guard let convertedTracker = getTracker(from: tracker) else { return [] }
            convertedTrackers.append(convertedTracker)
        }
        return convertedTrackers
    }
    
    //MARK: - Public Functions
    func addNewTracker(_ tracker: Tracker) throws {
        let newTracker = getTrackerCoreData(from: tracker)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("ERROR: \(StoreErrors.newTrackerSaveFailed.localizedDescription)")
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
}
