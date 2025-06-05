//
//  CategorySelectionViewModel.swift
//  Tracker
//
//  Created by Matthew on 01.06.2025.
//

import Foundation

typealias Binding<T> = (T) -> Void

protocol CategorySelectionDelegate: AnyObject {
    func selectCategory(_ category: String)
}

final class CategorySelectionViewModel {
    //MARK: - Bindings
    var categoryTitlesBinding: Binding<[String]>?
    
    //MARK: - Properties
    weak var delegate: CategorySelectionDelegate?
    var selectedCategory: String?

    private(set) var categoryTitles: [String] = [] {
        didSet { categoryTitlesBinding?(categoryTitles) }
    }
    private let store = Store()
    
    //MARK: - Init
    init(selectedCategory: String) {
        categoryTitles = store.categoryTitles
        self.selectedCategory = selectedCategory
    }
    
    //MARK: - Public Functions
    func addNewCategory(with title: String) {
        do {
            let _ = try store.addNewCategory(with: title)
        } catch {
            assertionFailure("ERROR: could not add new category with name: \(title)")
        }
        categoryTitles = Store().categoryTitles
    }
    
    func configureCategoryCollectionCell(_ cell: CategoryCollectionCell, indexPath: IndexPath) {
        cell.categoryTitle.text = categoryTitles[indexPath.row]
        
        
        if categoryTitles.count == 1 {
            cell.setupOneCategoryCell()
        } else {
            if indexPath.row == categoryTitles.count - 1 {
                cell.setupLastCell()
            } else if indexPath.row == 0 {
                cell.setupFirstCell()
            } else {
                cell.resetCellDownCornersBottomLine()
            }
        }
        
        if cell.categoryTitle.text == selectedCategory {
            cell.toggleCategory()
        } else {
            cell.checkmark.isHidden = true
        }
    }
    
    func updateSelectedCategory(_ index: Int) {
        selectedCategory = categoryTitles[index]
        guard let selectedCategory else { return }
        delegate?.selectCategory(selectedCategory)
    }
}
