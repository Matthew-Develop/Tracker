//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

protocol AddHabitViewControllerDelegate: AnyObject {
    func addNewHabit()
}

final class AddHabitViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    private let vStackNameTextField = UIStackView()
    private let nameTextField = CustomTextField()
    private let symbolLimitWarningLabel = UILabel()
    private let buttons = CustomAddTrackerButtons()
    private let categoryScheduleSelection = CustomCategoryAndScheduleSelection()
    
    //MARK: - Properties
    weak var delegate: AddHabitViewControllerDelegate?
    private var selectedCategory: String = ""

    
    //MARK: - Override
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
            if text.count > 38 {
                buttons.disableCreateButton()
                showSymbolLimitWarning()
            } else {
                buttons.enableCreateButton()
                hideSymbolLimitWarning()
            }
        } else {
            buttons.disableCreateButton()
        }
    }
    
    @objc private func showCategorySelection(_ sender: UIGestureRecognizer ) {
        let categorySelectorViewController = CategorySelectionViewController()
        
        categorySelectorViewController.delegate = self
        present(categorySelectorViewController, animated: true)
        
        UIView.animate(withDuration: 0.05) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                sender.view?.alpha = 1
            }
        }
    }
    
    private func showSymbolLimitWarning() {
        symbolLimitWarningLabel.isHidden = false
    }
    
    private func hideSymbolLimitWarning() {
        symbolLimitWarningLabel.isHidden = true
    }
}

//CategorySelectionDelegate
extension AddHabitViewController: CategorySelectionViewControllerDelegate {
    func selectCategory(_ category: String) {
        selectedCategory = category
    }
}

//Setup View
private extension AddHabitViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addVStackNameTextField()
        addCategoryScheduleSelection()
        addActionButtons()
        
        vStackNameTextField.addArrangedSubview(symbolLimitWarningLabel)
    }
    
    func addViewTitle() {
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
    
    func addVStackNameTextField() {
        addSymbolLimitWarning()

        vStackNameTextField.autoResizeOff()
        vStackNameTextField.axis = .vertical
        vStackNameTextField.spacing = 8
        vStackNameTextField.alignment = .center
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        vStackNameTextField.addArrangedSubview(nameTextField)
        view.addSubview(vStackNameTextField)
        NSLayoutConstraint.activate([
            vStackNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStackNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            nameTextField.leadingAnchor.constraint(equalTo: vStackNameTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: vStackNameTextField.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: vStackNameTextField.topAnchor)
        ])
    }
    
    func addCategoryScheduleSelection() {
        categoryScheduleSelection.setSelectedCategory("Важное")
        categoryScheduleSelection.setSelectedSchedule("Пт, Вт")
        
        let category = categoryScheduleSelection.subviews.first
        category?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCategorySelection)))
        
        view.addSubview(categoryScheduleSelection)
        NSLayoutConstraint.activate([
            categoryScheduleSelection.heightAnchor.constraint(equalToConstant: 150),

            categoryScheduleSelection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryScheduleSelection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryScheduleSelection.topAnchor.constraint(equalTo: vStackNameTextField.bottomAnchor, constant: 24)
        ])
    }
    
    func addActionButtons() {
        let cancelButton = buttons.arrangedSubviews[0] as? UIButton
        let createButton = buttons.arrangedSubviews[1] as? UIButton
        
        cancelButton?.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton?.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        let bottomConstraint = CGFloat(view.bounds.height < 812 ? -24 : -34)
        
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            
            buttons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstraint),
            buttons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func addSymbolLimitWarning() {
        symbolLimitWarningLabel.autoResizeOff()
        
        symbolLimitWarningLabel.text = "Ограничение  38 символов"
        symbolLimitWarningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        symbolLimitWarningLabel.textColor = .ypRed
        
        symbolLimitWarningLabel.isHidden = true
    }
}
