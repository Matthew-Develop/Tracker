//
//  TrackerStore.swift
//  Tracker
//
//  Created by Matthew on 21.05.2025.
//

import UIKit
import CoreData

struct TrackerStoreUpdate {
    let insertedIndex: IndexPath
    let deletedIndex: IndexPath
}

protocol TrackerStoreDelegate: AnyObject {
    func didTrackerStoreUpdate(_ update: TrackerStoreUpdate, store: TrackerStore)
}

final class TrackerStore: Store {
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
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
    
    weak var delegate: TrackerStoreDelegate?
    private var insertedIndex: IndexPath?
    private var deletedIndex: IndexPath?
    
    //MARK: - Stored Trackers
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
    func addNewTracker(_ tracker: Tracker, to categoryName: String) throws {
        let newTracker = getTrackerCoreData(from: tracker)
        guard let trackerCategory = TrackerCategoryStore().getTrackerCategory(from: categoryName)
        else {
            throw StoreErrors.categoriesFetchFailed
        }
        
        newTracker.category = trackerCategory
        
        try? context.save()
    }
    
    func eraseAllData() {
        let request = TrackerCoreData.fetchRequest()
        let result = try! context.fetch(request)
        
        for object in result {
            context.delete(object)
        }
        try! context.save()
    }
}

//MARK: - NSFetchedResultController Delegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndex = IndexPath()
        deletedIndex = IndexPath()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let insertedIndex,
              let deletedIndex
        else { return }
        delegate?.didTrackerStoreUpdate(
            TrackerStoreUpdate(insertedIndex: insertedIndex, deletedIndex: deletedIndex),
            store: self
        )
        
        self.insertedIndex = nil
        self.deletedIndex = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            insertedIndex = newIndexPath
        case .delete:
            deletedIndex = indexPath
        case .move: break
            
        case .update: break
            
        @unknown default:
            fatalError()
        }
    }
}
