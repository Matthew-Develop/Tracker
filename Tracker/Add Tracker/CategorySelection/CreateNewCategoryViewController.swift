//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Matthew on 01.05.2025.
//

import UIKit

protocol CreateNewCategoryViewControllerDelegate: AnyObject {
    func addNewCategory(with title: String)
}

final class CreateNewCategoryViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    private let categoryNameTextField = CustomTextField()
    private let vStackNameTextField = UIStackView()
    private let symbolLimitWarningLabel = UILabel()
    
    //MARK: - Properties
    weak var delegate: CreateNewCategoryViewControllerDelegate?
    
    private var existingCategories: [String] = []
    private var newCategory: String = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToHideKeyboard()
        
        existingCategories = Store().categoryTitles
        setupView()
    }
    
    //MARK: - Private Functions
    @objc private func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
        
        guard !newCategory.isEmpty
        else {
            assertionFailure("ERROR Creating new category")
            return
        }
        delegate?.addNewCategory(with: newCategory)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        toggleAddButton()
        newCategory = sender.text ?? ""
    }
    
    //MARK: - UI Updates
    private func disableDoneButton() {
        UIView.animate(withDuration: 0.1) {
            self.doneButton.backgroundColor = .ypGray
        }
        doneButton.isEnabled = false
    }
    
    private func enableDoneButton() {
        UIView.animate(withDuration: 0.1) {
            self.doneButton.backgroundColor = .ypBlack
        }
        doneButton.isEnabled = true
    }
    
    private func showWarning(with message: String) {
        symbolLimitWarningLabel.isHidden = false
        symbolLimitWarningLabel.text = message
    }
    
    private func hideWarning() {
        symbolLimitWarningLabel.isHidden = true
    }
    
    private func toggleWarning(_ title: String, name isValidName: Bool, exists isExistingCategory: Bool) {
        if !isValidName && title.count != 0 {
            if isExistingCategory {
                showWarning(with: "Категория уже существует")
            } else {
                showWarning(with: "Ограничение  \(Constants.symbolLimit) символов")
            }
            return
        } else {
            hideWarning()
        }
    }
    
    private func toggleAddButton() {
        guard let categoryTitle = categoryNameTextField.text
        else { return }
        
        let isExistingCategory = existingCategories.contains(where: {
            $0.lowercased() == categoryTitle.lowercased()
        })
        let isValidName = categoryTitle.count < Constants.symbolLimit && categoryTitle.count != 0 && !isExistingCategory
        
        if isValidName  {
            enableDoneButton()
        } else {
            disableDoneButton()
        }
        
        toggleWarning(categoryTitle, name: isValidName, exists: isExistingCategory)
    }
}

//MARK: - TextField Delegate
extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Setup View
private extension CreateNewCategoryViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addVStackNameTextField()
        addDoneButton()
        
        vStackNameTextField.addArrangedSubview(symbolLimitWarningLabel)
    }
    
    func addViewTitle() {
        titleLabel.autoResizeOff()
        
        titleLabel.text = "Новая категория"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addVStackNameTextField() {
        addSymbolLimitWarning()

        vStackNameTextField.autoResizeOff()
        vStackNameTextField.axis = .vertical
        vStackNameTextField.spacing = 8
        vStackNameTextField.alignment = .center
        
        categoryNameTextField.changePlaceholder(to: "Введите название категории")
        categoryNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        categoryNameTextField.delegate = self
        
        vStackNameTextField.addArrangedSubview(categoryNameTextField)
        view.addSubview(vStackNameTextField)
        NSLayoutConstraint.activate([
            vStackNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStackNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryNameTextField.leadingAnchor.constraint(equalTo: vStackNameTextField.leadingAnchor),
            categoryNameTextField.trailingAnchor.constraint(equalTo: vStackNameTextField.trailingAnchor),
            categoryNameTextField.topAnchor.constraint(equalTo: vStackNameTextField.topAnchor)
        ])
    }
    
    func addDoneButton() {
        doneButton.autoResizeOff()
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.backgroundColor = .ypGray
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        
        doneButton.isEnabled = false
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func addSymbolLimitWarning() {
        symbolLimitWarningLabel.autoResizeOff()
        
        symbolLimitWarningLabel.text = "Ограничение  \(Constants.symbolLimit) символов"
        symbolLimitWarningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        symbolLimitWarningLabel.textColor = .ypRed
        
        symbolLimitWarningLabel.isHidden = true
    }
}
