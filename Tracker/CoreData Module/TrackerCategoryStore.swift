//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Matthew on 21.05.2025.
//
import UIKit
import CoreData

final class TrackerCategoryStore: Store {
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
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

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
}
