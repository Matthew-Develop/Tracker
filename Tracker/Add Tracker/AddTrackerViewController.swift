//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    
    //MARK: - Properties
    var mainVC = UIViewController()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Private Functions
    @objc private func addHabitButtonTapped(_ sender: UIButton) {
        let addHabitViewController = AddHabitViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(addHabitViewController, animated: false)
    }
    
    @objc private func addUnregularButtonTapped(_ sender: UIButton) {
        let addUnregularViewController = AddUnregularViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(addUnregularViewController, animated: false)
    }
}

//MARK: - Setup View
extension AddTrackerViewController {
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addButtonsVStack()
    }
    
    private func addViewTitle() {
        titleLabel.autoResizeOff()
        
        titleLabel.text = NSLocalizedString("addTrackerVC.title", comment: "")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addButtonsVStack() {
        let addHabitButton = configureAddButton(
            withText: NSLocalizedString("addTrackerVC.habitButton", comment: "")
        )
        addHabitButton.addTarget(self, action: #selector(addHabitButtonTapped), for: .touchUpInside)
        
        let addUnregularButton = configureAddButton(
            withText: NSLocalizedString("addTrackerVC.unregularButton", comment: "")
        )
        addUnregularButton.addTarget(self, action: #selector(addUnregularButtonTapped), for: .touchUpInside)

        let vStack = UIStackView(arrangedSubviews: [addHabitButton, addUnregularButton])
        vStack.autoResizeOff()
        
        vStack.axis = .vertical
        vStack.spacing = 16
        
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: titleLabel.frame.height + 27)
        ])

    }
    
    private func configureAddButton(withText text: String) -> UIButton{
        let button = UIButton(type: .system)
        button.autoResizeOff()
        
        button.setTitle(text, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return button
    }
}
