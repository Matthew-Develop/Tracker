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
    private lazy var vStackNameTextField: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    private lazy var nameTextField: CustomTextField = {
        let nameTextField = CustomTextField()
        nameTextField.addTarget(
            self, action: #selector(textFieldDidChange), for: .editingChanged)
        nameTextField.delegate = self
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
    private lazy var symbolLimitWarningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        label.isHidden = true
        return label
    }()
    private lazy var categorySelection: CustomCategoryAndScheduleSelection = {
        let view = CustomCategoryAndScheduleSelection()
        let category = view.subviews.first
        let schedule = view.subviews.last
        
        category?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(showCategorySelection)
            )
        )
        schedule?.isHidden = true
        view.dividerView.isHidden = true
        return view
    }()
    
    //MARK: - Properties
    private var selectedCategory: String = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToHideKeyboard()
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
        toggleAddButton()
    }
    
    @objc private func showCategorySelection(_ sender: UIGestureRecognizer ) {
        let categorySelectionViewController = CategorySelectionViewController(selectedCategory: selectedCategory)
        categorySelectionViewController.delegate = self
        present(categorySelectionViewController, animated: true)
        
        UIView.animate(withDuration: 0.05) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.view?.alpha = 1
            }
        }
    }
    
    //MARK: - UI Updates
    private func toggleAddButton() {
        guard let trackerTitle = nameTextField.text
        else { return }
        
        let isValidName = trackerTitle.count < 38 && trackerTitle.count != 0
        let isCategorySelected = selectedCategory != ""
        
        updateCreateButtonState(name: isValidName, category: isCategorySelected)
        
        if !isValidName && trackerTitle.count != 0 {
            showWarning(with: "Ограничение  38 символов")
            return
        } else {
            hideWarning()
        }
    }
    
    private func updateCreateButtonState(name isValidName: Bool, category isCategorySelected: Bool) {
        let canEnableButton = isValidName && isCategorySelected
        canEnableButton ? buttons.enableCreateButton(): buttons.disableCreateButton()
    }
    
    private func showWarning(with message: String) {
        symbolLimitWarningLabel.isHidden = false
        symbolLimitWarningLabel.text = message
    }
    
    private func hideWarning() {
        symbolLimitWarningLabel.isHidden = true
    }
}

//MARK: - Extensions
extension AddUnregularViewController: CategorySelectionViewControllerDelegate {
    func selectCategory(_ category: String) {
        selectedCategory = category
        categorySelection.setSelectedCategory(selectedCategory)
        toggleAddButton()
    }
}

extension AddUnregularViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Setup View
private extension AddUnregularViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(titleLabel, vStackNameTextField, buttons, categorySelection)
        setupVStack()
        setupConstraints()
    }
    
    func setupVStack() {
        vStackNameTextField.addArrangedSubviews(
            nameTextField, symbolLimitWarningLabel
        )
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            vStackNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStackNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: vStackNameTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: vStackNameTextField.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: vStackNameTextField.topAnchor),
            
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categorySelection.heightAnchor.constraint(equalToConstant: 75),
            categorySelection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySelection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categorySelection.topAnchor.constraint(equalTo: vStackNameTextField.bottomAnchor, constant: 24)
        ])
    }
}

