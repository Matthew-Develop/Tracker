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
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
}
