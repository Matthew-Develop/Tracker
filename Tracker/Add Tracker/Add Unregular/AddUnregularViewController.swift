//
//  AddUnregularViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class AddUnregularViewController: UIViewController {
    //Views
    private let titleLabel = UILabel()
    private let nameTextField = CustomTextField()
    private let buttons = CustomAddTrackerButtons()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Private Functions
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        if !text.isEmpty {
            buttons.enableCreateButton()
        } else {
            buttons.disableCreateButton()
        }
    }
}

private extension AddUnregularViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addNameTextField()
        addActionButtons()
    }
    
    func addViewTitle() {
        titleLabel.autoResizeOff()
        
        titleLabel.text = "Новое нерегулярное событие"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addNameTextField() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38)
        ])
    }
    
    func addActionButtons() {
        let cancelButton = buttons.arrangedSubviews[0] as? UIButton
        let createButton = buttons.arrangedSubviews[1] as? UIButton
        
        cancelButton?.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton?.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

