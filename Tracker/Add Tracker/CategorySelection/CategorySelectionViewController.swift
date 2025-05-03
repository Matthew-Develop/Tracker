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
    
    
    //MARK: - Properties
    weak var delegate: CategorySelectionViewControllerDelegate?
    private var categories: [TrackerCategory] = []
    var selectedCategory: String = ""
    
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        categories = MockData().categories
    }
    
    @objc private func createCategoryButtonTapped(_ sender: UIButton) {
        let createNewCategoryViewController = CreateNewCategoryViewController()
        
        present(createNewCategoryViewController, animated: true)
    }
    
    private func configureCell(cell: CategoryCollectionCell, indexPath: IndexPath) {
        cell.categoryTitle.text = categories[indexPath.row].title
        
        if indexPath.row == categories.count - 1 {
            cell.bottomLine.isHidden = true
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
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
        return CGSize(width: view.frame.width - 32, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

//Setup View
private extension CategorySelectionViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addCreateCategoryButton()
//        addIfEmpty()
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
        let image = UIImageView()
        image.autoResizeOff()
        
        image.image = UIImage(named: "IfEmptyTrackers")
        
        let textLabel = UILabel()
        textLabel.autoResizeOff()
        
        textLabel.text = "Привычки и события можно\nобъеденить по смыслу"
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .ypBlack
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        
        view.addSubview(image)
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),
            
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -30),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)
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
