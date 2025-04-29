//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class AddHabitViewController: UIViewController {
    //Views
    private let titleLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

extension AddHabitViewController {
    private func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addActionButtons()
    }
    
    private func addViewTitle() {
        titleLabel.autoResizeOff()
        
        titleLabel.text = "Новая привычка"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addActionButtons() {
        let buttons = CustomAddTrackerButtons()
        
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
