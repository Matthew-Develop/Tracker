//
//  AddUnregularViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class AddUnregularViewController: UIViewController {
    //MARK: Views
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Новое нерегулярное событие"
        title.font = .systemFont(ofSize: 16, weight: .medium)
        title.textColor = .ypBlack
        return title
    }()
    private lazy var nameTextField: CustomTextField = {
        let nameTextField = CustomTextField()
        nameTextField.addTarget(
            self, action: #selector(textFieldDidChange), for: .editingChanged)
        return nameTextField
    }()
    private lazy var buttons: CustomAddTrackerButtons = {
        let buttons = CustomAddTrackerButtons()
        let cancelButton = buttons.arrangedSubviews[0] as? UIButton
        let createButton = buttons.arrangedSubviews[1] as? UIButton
        
        cancelButton?.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton?.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return buttons
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Private Functions
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        //TODO:  Обработка нажатия кнопки создания нерегулярного события
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let nameText = sender.text else { return }
        
        let isValidName = !nameText.isEmpty
        
        updateCreateButtonState(name: isValidName)
    }
    
    private func updateCreateButtonState(name isValidName: Bool) {
        let canEnableButton = isValidName
        canEnableButton ? buttons.enableCreateButton(): buttons.disableCreateButton()
    }
}

private extension AddUnregularViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(titleLabel, nameTextField, buttons )
        setupConstraints()
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

