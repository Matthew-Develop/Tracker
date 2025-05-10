//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Matthew on 01.05.2025.
//

import UIKit

protocol CategorySelectionViewControllerDelegate: AnyObject {
    func selectCategory(_ category: String)
}

final class CategorySelectionViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    private let addCategoryButton = UIButton(type: .system)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let ifEmptyImage = UIImageView()
    private let ifEmptyTextLabel = UILabel()
    
    
    //MARK: - Properties
    weak var delegate: CategorySelectionViewControllerDelegate?
    private var categories: [TrackerCategory] = []
    var selectedCategory: String = ""
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        categories = MockData().categories
        reloadData()
    }
    
    @objc private func createCategoryButtonTapped(_ sender: UIButton) {
        let createNewCategoryViewController = CreateNewCategoryViewController()
        
        createNewCategoryViewController.delegate = self
        present(createNewCategoryViewController, animated: true)
    }
    
    private func configureCell(cell: CategoryCollectionCell, indexPath: IndexPath) {
        cell.categoryTitle.text = categories[indexPath.row].title
        
        if indexPath.row == categories.count - 1 {
            cell.bottomLine.isHidden = true
            cell.setDownCellCorners()
        } else if indexPath.row == 0 {
            cell.setUpCellCorners()
        }
        
        if cell.categoryTitle.text == selectedCategory {
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.toggleCategory()
        }
    }
    
    private func reloadData() {
        collectionView.reloadData()
        
        let isEmpty = categories.isEmpty
        collectionView.isHidden = isEmpty
        ifEmptyImage.isHidden = !isEmpty
        ifEmptyTextLabel.isHidden = !isEmpty
    }
}

//Create New Category Delegate
extension CategorySelectionViewController: CreateNewCategoryViewControllerDelegate {
    func addNewCategory(with title: String) {
        
        let newCategory = TrackerCategory(title: title, trackers: [])
        let tempCategories = categories
        let updatedCategories = tempCategories + [newCategory]
        let index = IndexPath(row: tempCategories.count, section: 0)
        
        categories = updatedCategories
    
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [index])
        }
        
        let preLastCell = collectionView.cellForItem(at: IndexPath(row: index.row - 1, section: 0)) as? CategoryCollectionCell
        let lastCell = collectionView.cellForItem(at: index) as? CategoryCollectionCell
        
        preLastCell?.resetCellDownCornersBottomLine()
        lastCell?.setDownCellCorners()
    }
}

//UICollectionViewDataSource
extension CategorySelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reuseIdentifier, for: indexPath) as? CategoryCollectionCell
        else { return UICollectionViewCell() }
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

//UICollectionViewDelegateFlowLayout
extension CategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 32, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension CategorySelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionCell
        else { return }
        
        selectedCategory = categories[indexPath.row].title
        cell.toggleCategory()
        cell.animateTap()
        delegate?.selectCategory(selectedCategory)
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionCell
        else { return }
        
        cell.toggleCategory()
    }
}

//Setup View
private extension CategorySelectionViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addCreateCategoryButton()
        addIfEmpty()
        addCategoriesCollectionView()
    }
    
    func addViewTitle() {
        titleLabel.autoResizeOff()
        
        titleLabel.text = "Категория"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addIfEmpty() {
        ifEmptyImage.autoResizeOff()
        
        ifEmptyImage.image = UIImage(named: "IfEmptyTrackers")
        
        ifEmptyTextLabel.autoResizeOff()
        
        ifEmptyTextLabel.text = "Привычки и события можно\nобъеденить по смыслу"
        ifEmptyTextLabel.font = .systemFont(ofSize: 12, weight: .medium)
        ifEmptyTextLabel.textColor = .ypBlack
        ifEmptyTextLabel.numberOfLines = 2
        ifEmptyTextLabel.textAlignment = .center
        
        view.addSubview(ifEmptyImage)
        view.addSubview(ifEmptyTextLabel)
        NSLayoutConstraint.activate([
            ifEmptyImage.widthAnchor.constraint(equalToConstant: 80),
            ifEmptyImage.heightAnchor.constraint(equalToConstant: 80),
            
            ifEmptyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ifEmptyImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -30),
            
            ifEmptyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ifEmptyTextLabel.topAnchor.constraint(equalTo: ifEmptyImage.bottomAnchor, constant: 8)
        ])
    }
    
    func addCreateCategoryButton() {
        addCategoryButton.autoResizeOff()
        
        addCategoryButton.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.ypWhite, for: .normal)
        addCategoryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.layer.masksToBounds = true
        
        view.addSubview(addCategoryButton)
        NSLayoutConstraint.activate([
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addCategoriesCollectionView() {
        collectionView.autoResizeOff()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = 24
        
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            collectionView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -14)
        ])
    }
}
