//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Matthew on 21.05.2025.
//
import UIKit
import CoreData

struct TrackerCategoryUpdate {
    
}

final class TrackerCategoryStore: Store {
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
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
    
    var trackerCategories: [TrackerCategory] {
        let trackerCategories = fetchedResultsController.fetchedObjects ?? []
        var convertedTrackerCategories: [TrackerCategory] = []
        
        for category in trackerCategories {
            guard let convertedCategory = getTrackerCategory(from: category) else { return [] }
            convertedTrackerCategories.append(convertedCategory)
        }
        
        return convertedTrackerCategories
    }
    var categoryTitles: [String] {
        var categoryTitles: [String] = []
        for category in trackerCategories {
            categoryTitles.append(category.title)
        }
        return categoryTitles
    }
    
    //MARK: - Public Functions
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
        print("Fetched category from categoryName, title: \(category.title ?? "not found")")
        return category
    }
    
    func eraseAllData() {
        let request = TrackerCategoryCoreData.fetchRequest()
        let result = try! context.fetch(request)
        
        for object in result {
            context.delete(object)
        }
        try! context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
}
