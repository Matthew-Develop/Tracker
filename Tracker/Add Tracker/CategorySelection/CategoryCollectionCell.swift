//
//  CategoryCollectionCell.swift
//  Tracker
//
//  Created by Matthew on 03.05.2025.
//

import UIKit

final class CategoryCollectionCell: UICollectionViewCell {
    //Views
    let categoryTitle = UILabel()
    let bottomLine = UIView()
    
    //MARK: - Properties
    static let reuseIdentifier = "CategoryCollectionCell"
    
    //MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Functions
    @objc private func categoryTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.view?.alpha = 1
            }
        }
    }
}

//Setup View
private extension CategoryCollectionCell {
    func setupView() {
        contentView.backgroundColor = .ypBackground
        
        addCategoryTitle()
        addBottomLine()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryTapped)))
    }
    
    func addCategoryTitle() {
        categoryTitle.autoResizeOff()
        
        categoryTitle.textColor = .ypBlack
        categoryTitle.font = .systemFont(ofSize: 17, weight: .regular)
        
        addSubview(categoryTitle)
        NSLayoutConstraint.activate([
            categoryTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addBottomLine() {
        bottomLine.autoResizeOff()
        
        bottomLine.backgroundColor = .ypGray
        
        addSubview(bottomLine)
        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
