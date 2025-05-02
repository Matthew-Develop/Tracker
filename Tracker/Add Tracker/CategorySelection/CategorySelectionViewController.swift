//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Matthew on 01.05.2025.
//

import UIKit

protocol CategorySelectionViewControllerDelegate: AnyObject {
    func selectCategory()
    func createNewCategory()
}

final class CategorySelectionViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @objc private func createCategoryButtonTapped(_ sender: UIButton) {
        let createNewCategoryViewController = CreateNewCategoryViewController()
        
        present(createNewCategoryViewController, animated: true)
    }
}

private extension CategorySelectionViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addCreateCategoryButton()
        addIfEmpty()
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
        
        
        view.addSubview(image)
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),
            
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height - titleLabel.frame.height - 27 - 60 - 16),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)
        ])
    }
    
     func addCreateCategoryButton() {
        let button = UIButton(type: .system)
        button.autoResizeOff()
        
        button.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
