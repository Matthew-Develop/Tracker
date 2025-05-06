//
//  CategoryCollectionCell.swift
//  Tracker
//
//  Created by Matthew on 03.05.2025.
//

import UIKit

final class CategoryCollectionCell: UICollectionViewCell {
    //MARK: Views
    let categoryTitle = UILabel()
    let bottomLine = UIView()
    var checkmark = UIImageView()
    
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
    
    func setUpCellCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setDownCellCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func resetCellDownCornersBottomLine() {
        layer.masksToBounds = true
        layer.cornerRadius = 0
        layer.maskedCorners = []
        bottomLine.isHidden = false
    }
}

//Setup View
private extension CategoryCollectionCell {
    func setupView() {
        contentView.backgroundColor = .ypBackground
        
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
        
        checkmark.image = UIImage(named: "CheckmarkCategorySelected")
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
