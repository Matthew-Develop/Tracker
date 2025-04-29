//
//  CustomAddTrackerButtons.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class CustomAddTrackerButtons: UIStackView {
    
    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    
    var isCreateButtonActive: Bool = true
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomAddTrackerButtons {
    private func setupView() {
        self.autoResizeOff()
        
        self.backgroundColor = .ypWhite
        self.spacing = 8
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.addArrangedSubview(cancelButton)
        self.addArrangedSubview(createButton)
        
        addCancelButton()
        addCreateButton()
    }
    
    private func addCancelButton() {
        cancelButton.autoResizeOff()
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        cancelButton.backgroundColor = .ypWhite
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }
    
    private func addCreateButton() {
        createButton.autoResizeOff()
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(isCreateButtonActive ? .ypWhite : .ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        createButton.backgroundColor = isCreateButtonActive ? .ypBlack : .ypGray
        
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        
        if !isCreateButtonActive {
            createButton.isEnabled = false
        }
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60),

            createButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            createButton.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }
}
