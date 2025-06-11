//
//  CategoryCollectionCell.swift
//  Tracker
//
//  Created by Matthew on 03.05.2025.
//

import UIKit

final class CategoryCollectionCell: UITableViewCell {
    //MARK: Views
    let categoryTitle = UILabel()
    let bottomLine = UIView()
    let checkmark = UIImageView()
    
    //MARK: - Properties
    static let reuseIdentifier = "CategoryCollectionCell"
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        resetAllCellsCorners()
    }
    
    //MARK: - Public Functions
    func toggleCategory() {
        checkmark.isHidden = !checkmark.isHidden
    }
    
    func animateTap() {
        UIView.animate(withDuration: 0.05) {
            self.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.alpha = 1
            }
        }
    }
    
    func setupOneCategoryCell() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        bottomLine.isHidden = true
    }
    
    func setupFirstCell() {
        resetAllCellsCorners()
        bottomLine.isHidden = false
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupLastCell() {
        resetAllCellsCorners()
        bottomLine.isHidden = true
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func resetCellDownCornersBottomLine() {
        resetAllCellsCorners()
        bottomLine.isHidden = false
    }
    
    //MARK: - Private Functions
    private func resetAllCellsCorners() {
        contentView.layer.cornerRadius = 0
    }
}

//MARK: - Setup View
private extension CategoryCollectionCell {
    func setupView() {
        contentView.backgroundColor = .ypBackground
        contentView.layer.masksToBounds = true
        
        addCategoryTitle()
        addCheckmark()
        addBottomLine()
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
    
    func addCheckmark() {
        checkmark.autoResizeOff()
        
        checkmark.image = Asset.Images.checkmarkCategorySelected.image
        checkmark.tintColor = .ypBlue
        checkmark.isHidden = true
        
        addSubview(checkmark)
        NSLayoutConstraint.activate([
            checkmark.heightAnchor.constraint(equalToConstant: 24),
            checkmark.widthAnchor.constraint(equalToConstant: 24),
            
            checkmark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmark.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addBottomLine() {
        bottomLine.backgroundColor = .ypGray
        
        addSubviews(bottomLine)
        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
