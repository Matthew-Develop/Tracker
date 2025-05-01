//
//  CustomAddTrackerButtons.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class CustomAddTrackerButtons: UIStackView {
    //Views
    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Functions
    func disableCreateButton() {
        UIView.animate(withDuration: 0.1) {
            self.createButton.backgroundColor = .ypGray
        }
        createButton.isEnabled = false
    }
    
    func enableCreateButton() {
        UIView.animate(withDuration: 0.1) {
            self.createButton.backgroundColor = .ypBlack
        }
        createButton.isEnabled = true
    }
}

//Setup View
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
        
        createButton.isEnabled = false
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        createButton.backgroundColor = .ypGray
        
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60),

            createButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            createButton.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }
}
