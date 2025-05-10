//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

protocol AddHabitViewControllerDelegate: AnyObject {
    func addNewHabit(category: TrackerCategory)
}

final class AddHabitViewController: UIViewController {
    //MARK: Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    private let vStackNameTextField = UIStackView()
    private let nameTextField = CustomTextField()
    private let symbolLimitWarningLabel = UILabel()
    private let buttons = CustomAddTrackerButtons()
    private let categoryScheduleSelection = CustomCategoryAndScheduleSelection()
    
    //MARK: - Properties
    weak var delegate: AddHabitViewControllerDelegate?
    private var selectedCategory: String = ""
    private var selectedSchedule: [String] = []
    
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
        guard let categoryToAdd = configureCategoryToAdd()
        else { return }
        
        delegate?.addNewHabit(category: categoryToAdd)
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        toggleAddButton()
    }
    
    @objc private func showCategorySelection(_ sender: UIGestureRecognizer ) {
        let categorySelectionViewController = CategorySelectionViewController()
        
        categorySelectionViewController.delegate = self
        categorySelectionViewController.selectedCategory = selectedCategory
        present(categorySelectionViewController, animated: true)
        
        UIView.animate(withDuration: 0.05) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.view?.alpha = 1
            }
        }
    }
    
    @objc private func showScheduleSelection(_ sender: UITapGestureRecognizer) {
        let scheduleSelectionViewController = ScheduleSelectionViewController()
        
        scheduleSelectionViewController.delegate = self
        for day in selectedSchedule {
            scheduleSelectionViewController.selectedSchedule[day] = true
        }
        present(scheduleSelectionViewController, animated: true)
        
        UIView.animate(withDuration: 0.05) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.view?.alpha = 1
            }
        }
    }
    
    private func showWarning(with message: String) {
        symbolLimitWarningLabel.isHidden = false
        symbolLimitWarningLabel.text = message
    }
    
    private func hideWarning() {
        symbolLimitWarningLabel.isHidden = true
    }
    
    private func configureCategoryToAdd() -> TrackerCategory? {
        guard let trackerTitle = nameTextField.text
        else {
            print("Title text field is empty")
            dismiss(animated: true)
            return nil
        }
        
        let newTracker = Tracker(
            title: trackerTitle,
            color: .brown,
            emoji: "🔥",
            schedule: selectedSchedule
        )
        
        let categoryToAdd = TrackerCategory(
            title: selectedCategory,
            trackers: [newTracker]
        )
        
        return categoryToAdd
    }
    
    private func toggleAddButton() {
        guard let trackerTitle = nameTextField.text
        else { return }
        
        let isValidName = trackerTitle.count < 38 && trackerTitle.count != 0
        let isCategorySelected = selectedCategory != ""
        let isScheduleSelected = selectedSchedule.count != 0
        
        updateCreateButtonState(name: isValidName, category: isCategorySelected, schedule: isScheduleSelected)
        
        if !isValidName && trackerTitle.count != 0 {
            showWarning(with: "Ограничение  38 символов")
            return
        } else {
            hideWarning()
        }
    }
    
    private func updateCreateButtonState(name isValidName: Bool, category isCategorySelected: Bool, schedule isScheduleSelected: Bool) {
        let canEnableButton = isValidName && isCategorySelected && isScheduleSelected
        canEnableButton ? buttons.enableCreateButton() : buttons.disableCreateButton()
    }
}

//Category Selection Delegate
extension AddHabitViewController: CategorySelectionViewControllerDelegate {
    func selectCategory(_ category: String) {
        selectedCategory = category
        categoryScheduleSelection.setSelectedCategory(selectedCategory)
        toggleAddButton()
    }
}

//Schedule Selection Delegate
extension AddHabitViewController: ScheduleSelectionViewControllerDelegate {
    func selectSchedule(_ schedule: [String]) {
        selectedSchedule = schedule
        if schedule.count == 7 {
            categoryScheduleSelection.setSelectedSchedule(["Каждый день"])
        } else {
            categoryScheduleSelection.setSelectedSchedule(selectedSchedule)
        }
        toggleAddButton()
    }
}

//TextField Delegate
extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        nameTextField.delegate = self
        
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
        let category = categoryScheduleSelection.subviews.first
        let schedule = categoryScheduleSelection.subviews.last
        category?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCategorySelection)))
        schedule?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScheduleSelection)))
        
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
        symbolLimitWarningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        symbolLimitWarningLabel.textColor = .ypRed
        symbolLimitWarningLabel.isHidden = true
    }
}
