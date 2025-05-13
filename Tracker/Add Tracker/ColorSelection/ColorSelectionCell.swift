//
//  ColorSelectionCell.swift
//  Tracker
//
//  Created by Matthew on 13.05.2025.
//

import UIKit

final class ColorSelectionCell: UICollectionViewCell {
    //Views
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: - Properties
    static let reuseIdentifier: String = "ColorSelectionCell"
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Updates
    func selectCell() {
        UIView.animate(withDuration: 0.1) {
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 8
            self.layer.borderColor = self.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            self.colorView.bounds.size.width += 2
        }
    }
    
    func deselectCell() {
        UIView.animate(withDuration: 0.1) {
            self.layer.borderWidth = 0
        }
    }
}

//Setup View 
private extension ColorSelectionCell {
    func setupView() {
        backgroundColor = .clear
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubviews(colorView)
        NSLayoutConstraint.activate([
//            colorView.widthAnchor.constraint(equalToConstant: 40),
//            colorView.heightAnchor.constraint(equalToConstant: 40),
//            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }
}
