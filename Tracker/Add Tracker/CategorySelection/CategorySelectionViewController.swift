//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Matthew on 01.05.2025.
//

import UIKit

final class CategorySelectionViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    private let addCategoryButton = UIButton(type: .system)
    private let ifEmptyImage = UIImageView()
    private let ifEmptyTextLabel = UILabel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset.top = 24
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()
    
    //MARK: - Properties
    var viewModel: CategorySelectionViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadData()
    }
    
    //MARK: - Public Functions
    func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.categoryTitlesBinding = {[weak self] _ in
            self?.reloadData()
            print("Categories changed")
        }
    }
    
    //MARK: - Private Functions
    @objc private func createCategoryButtonTapped(_ sender: UIButton) {
        let createNewCategoryViewController = CreateNewCategoryViewController()
        
        createNewCategoryViewController.delegate = self
        present(createNewCategoryViewController, animated: true)
    }
    
    private func reloadData() {
        tableView.reloadData()
        
        guard let viewModel else { return }
        let isEmpty = viewModel.categoryTitles.isEmpty
        tableView.isHidden = isEmpty
        ifEmptyImage.isHidden = !isEmpty
        ifEmptyTextLabel.isHidden = !isEmpty
    }
}

//MARK: - Create New Category Delegate
extension CategorySelectionViewController: CreateNewCategoryViewControllerDelegate {
    func addNewCategory(with title: String) {
        viewModel?.addNewCategory(with: title)
        reloadData()
    }
}

//MARK: - TableView DataSource
extension CategorySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCollectionCell.reuseIdentifier, for: indexPath) as? CategoryCollectionCell
        else { return UITableViewCell() }
        
        viewModel?.configureCategoryCollectionCell(cell, indexPath: indexPath)
        return cell
    }
}

//MARK: - TableView Delegate
extension CategorySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCollectionCell,
              let viewModel
        else { return }
        
        viewModel.updateSelectedCategory(indexPath.row)
        cell.toggleCategory()
        cell.animateTap()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCollectionCell
        else { return }
        
        cell.toggleCategory()
    }
}

//MARK: - Setup View
private extension CategorySelectionViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addCreateCategoryButton()
        addIfEmpty()
        addTableView()
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
    
    func addTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCollectionCell.self, forCellReuseIdentifier: CategoryCollectionCell.reuseIdentifier)
        view.addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -14)
        ])
    }
}
