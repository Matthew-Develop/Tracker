//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class AddHabitViewController: UIViewController {
    //MARK: Views
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset.top = 24
        return scrollView
    }()
    private lazy var stackContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
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
        collectionView.register(ColorSelectionCell.self, forCellWithReuseIdentifier: ColorSelectionCell.reuseIdentifier)
        collectionView.accessibilityIdentifier = "colorCollectionView"
        return collectionView
    }()
    
    //MARK: - Properties
    private let store = Store()
    
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
        
        try? store.addNewTracker(categoryToAdd.trackers[0], to: categoryToAdd.title)
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        toggleAddButton()
    }
    
    @objc private func showCategorySelection(_ sender: UIGestureRecognizer ) {
        let categorySelectionViewController = CategorySelectionViewController()
        
        let viewModel = CategorySelectionViewModel(selectedCategory: selectedCategory)
        viewModel.delegate = self
        
        categorySelectionViewController.viewModel = viewModel
        categorySelectionViewController.bind()
        
        present(categorySelectionViewController, animated: true)
        
        UIView.animate(withDuration: 0.05) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.view?.alpha = 1
            }
        }
    }
    
    @objc private func showScheduleSelection(_ sender: UITapGestureRecognizer) {
        let scheduleSelectionViewController = ScheduleSelectionViewController(selectedSchedule: selectedSchedule)
        scheduleSelectionViewController.delegate = self
        present(scheduleSelectionViewController, animated: true)
        
        UIView.animate(withDuration: 0.05) {
            sender.view?.alpha = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                sender.view?.alpha = 1
            }
        }
    }
    
    private func configureCategoryToAdd() -> TrackerCategory? {
        guard let trackerTitle = nameTextField.text,
              let color = selectedColor,
              let emoji = selectedEmoji
        else {
            print("Title text field is empty")
            dismiss(animated: true)
            return nil
        }
        
        let newTracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: color,
            emoji: emoji,
            schedule: selectedSchedule
        )
        
        let categoryToAdd = TrackerCategory(
            title: selectedCategory,
            trackers: [newTracker]
        )
        
        return categoryToAdd
    }
    
    private func configureCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView.accessibilityIdentifier == "emojiCollectionView" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionCell.reuseIdentifier, for: indexPath) as? EmojiCollectionCell
            else { return UICollectionViewCell() }
            
            cell.emojiImageView.image = SelectionArrays.emojiArray[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectionCell.reuseIdentifier, for: indexPath) as? ColorSelectionCell
            else { return UICollectionViewCell() }
            
            cell.colorView.backgroundColor = SelectionArrays.colorArray[indexPath.row]
            return cell
        }
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
        let isColorSelected = selectedColor != nil
        
        updateCreateButtonState(
            name: isValidName,
            category: isCategorySelected,
            schedule: isScheduleSelected,
            emoji: isEmojiSelected,
            color: isColorSelected
        )
        
        if !isValidName && trackerTitle.count != 0 {
            showWarning(with: "Ограничение  38 символов")
            return
        } else {
            hideWarning()
        }
    }
    
    private func updateCreateButtonState(
        name isValidName: Bool,
        category isCategorySelected: Bool,
        schedule isScheduleSelected: Bool,
        emoji isEmojiSelected: Bool,
        color isColorSelected: Bool) {
        let canEnableButton = isValidName && isCategorySelected && isScheduleSelected && isEmojiSelected && isColorSelected
        canEnableButton ? buttons.enableCreateButton() : buttons.disableCreateButton()
    }
    
    private func cellToggle(toSelect: Bool, _ collectionView: UICollectionView, at indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == "emojiCollectionView" {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionCell
            else { return }
            if toSelect {
                cell.selectCell()
                selectedEmoji = cell.emojiImageView.image
            } else {
                cell.deselectCell()
            }
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorSelectionCell
            else { return }
            if toSelect {
                cell.selectCell()
                selectedColor = cell.colorView.backgroundColor
            } else {
                cell.deselectCell()
            }
        }
    }
}

//MARK: - Category Selection Delegate
extension AddHabitViewController: CategorySelectionDelegate {
    func selectCategory(_ category: String) {
        selectedCategory = category
        categoryScheduleSelection.setSelectedCategory(selectedCategory)
        toggleAddButton()
    }
}

//MARK: - Schedule Selection Delegate
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

//MARK: - Collection View DataSource and Delegate
extension AddHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        configureCell(in: collectionView, at: indexPath)
    }
}
extension AddHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let side = CGFloat(view.bounds.height < 600 ? UIConstants.emojiColorCellSizeSmall : UIConstants.emojiColorCellSizeBig)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        view.bounds.height < 600 ? 0 : 5
    }
}
extension AddHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellToggle(toSelect: true, collectionView, at: indexPath)
        toggleAddButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        cellToggle(toSelect: false, collectionView, at: indexPath)
    }
}

//MARK: - TextField Delegate
extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Setup View
private extension AddHabitViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addActionButtons()
        
        setupScrollView()
        addVStackNameTextField()
        addCategoryScheduleSelection()
        setupEmojiCollectionView()
        setupColorCollectionView()
        
        vStackNameTextField.addArrangedSubviews(symbolLimitWarningLabel)
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

        vStackNameTextField.axis = .vertical
        vStackNameTextField.spacing = 8
        vStackNameTextField.alignment = .center
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nameTextField.delegate = self
        
        vStackNameTextField.addArrangedSubviews(nameTextField)
        stackContentView.addArrangedSubviews(vStackNameTextField)
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: vStackNameTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: vStackNameTextField.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: vStackNameTextField.topAnchor),
            
            vStackNameTextField.topAnchor.constraint(equalTo: stackContentView.topAnchor),
            vStackNameTextField.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            vStackNameTextField.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            vStackNameTextField.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor)
        ])
    }
    
    func addCategoryScheduleSelection() {
        let category = categoryScheduleSelection.subviews.first
        let schedule = categoryScheduleSelection.subviews.last
        category?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCategorySelection)))
        schedule?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showScheduleSelection)))
        
        stackContentView.addArrangedSubviews(categoryScheduleSelection)
        NSLayoutConstraint.activate([
            categoryScheduleSelection.heightAnchor.constraint(equalToConstant: 150),
            categoryScheduleSelection.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            categoryScheduleSelection.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
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
        symbolLimitWarningLabel.font = .systemFont(ofSize: 17, weight: .regular)
        symbolLimitWarningLabel.textColor = .ypRed
        symbolLimitWarningLabel.isHidden = true
    }
    
    func setupEmojiCollectionView() {
//        view.addSubviews(emojiTitle, emojiCollectionView)
        stackContentView.setCustomSpacing(32, after: categoryScheduleSelection)
        stackContentView.addArrangedSubviews(emojiTitle, emojiCollectionView)
        NSLayoutConstraint.activate([
            emojiTitle.topAnchor.constraint(equalTo: categoryScheduleSelection.bottomAnchor, constant: 60),
            emojiTitle.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor, constant: 12),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: UIConstants.emojiColorCellSizeBig * 3)
        ])
    }
    
    func setupColorCollectionView() {
//        view.addSubviews(colorTitle, colorCollectionView)
        stackContentView.setCustomSpacing(40, after: emojiCollectionView)
        stackContentView.addArrangedSubviews(colorTitle, colorCollectionView)
        NSLayoutConstraint.activate([
            colorTitle.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            colorTitle.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor, constant: 12),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 24),
            colorCollectionView.heightAnchor.constraint(equalToConstant: UIConstants.emojiColorCellSizeBig * 3),

            colorCollectionView.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
        ])
    }
    
    func setupScrollView() {
        scrollView.addSubviews(stackContentView)
        view.addSubviews(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttons.topAnchor),
            
            stackContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
}
