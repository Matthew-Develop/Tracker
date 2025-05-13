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
    private lazy var emojiTitle: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    private lazy var colorTitle: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCollectionCell.self, forCellWithReuseIdentifier: EmojiCollectionCell.reuseIdentifier)
        collectionView.accessibilityIdentifier = "emojiCollectionView"
        return collectionView
    }()
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.accessibilityIdentifier = "colorCollectionView"
        return collectionView
    }()
    
    //MARK: - Properties
    weak var delegate: AddHabitViewControllerDelegate?
    private var selectedCategory: String = ""
    private var selectedSchedule: [String] = []
    private var selectedEmoji: UIImage?
    private var selectedColor: UIColor?
    
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

    //MARK: - UI Updates
    private func showWarning(with message: String) {
        symbolLimitWarningLabel.isHidden = false
        symbolLimitWarningLabel.text = message
    }
    
    private func hideWarning() {
        symbolLimitWarningLabel.isHidden = true
    }
    
    private func toggleAddButton() {
        guard let trackerTitle = nameTextField.text
        else { return }
        
        let isValidName = trackerTitle.count < 38 && trackerTitle.count != 0
        let isCategorySelected = selectedCategory != ""
        let isScheduleSelected = selectedSchedule.count != 0
        let isEmojiSelected = selectedEmoji != nil
        
        updateCreateButtonState(name: isValidName, category: isCategorySelected, schedule: isScheduleSelected, emoji: isEmojiSelected)
        
        if !isValidName && trackerTitle.count != 0 {
            showWarning(with: "Ограничение  38 символов")
            return
        } else {
            hideWarning()
        }
    }
    
    private func updateCreateButtonState(name isValidName: Bool, category isCategorySelected: Bool, schedule isScheduleSelected: Bool, emoji isEmojiSelected: Bool) {
        let canEnableButton = isValidName && isCategorySelected && isScheduleSelected && isEmojiSelected
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

extension AddHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.accessibilityIdentifier == "emojiCollectionView" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionCell.reuseIdentifier, for: indexPath) as? EmojiCollectionCell
            else { return UICollectionViewCell() }
            
            cell.emojiImageView.image = SelectionArrays.emojiArray[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            cell.backgroundColor = SelectionArrays.colorArray[indexPath.row]
            
            return cell
        }
    }
}

extension AddHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIConstants.emojiColorCellSizeBig
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}

extension AddHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionCell
        else { return }
        cell.selectCell()
        selectedEmoji = cell.emojiImageView.image
        toggleAddButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionCell
        else { return }
        cell.deselectCell()
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
        setupEmojiCollectionView()
        setupColorCollectionView()
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
        
        view.addSubviews(buttons)
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
    
    func setupEmojiCollectionView() {
        view.addSubviews(emojiTitle, emojiCollectionView)
        NSLayoutConstraint.activate([
            emojiTitle.topAnchor.constraint(equalTo: categoryScheduleSelection.bottomAnchor, constant: 32),
            emojiTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitle.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: UIConstants.emojiColorCellSizeBig * 3)
        ])
    }
    
    func setupColorCollectionView() {
        view.addSubviews(colorTitle, colorCollectionView)
        NSLayoutConstraint.activate([
            colorTitle.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            colorTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 24),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            colorCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
