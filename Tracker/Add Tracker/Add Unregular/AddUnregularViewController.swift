//
//  AddUnregularViewController.swift
//  Tracker
//
//  Created by Matthew on 25.04.2025.
//

import UIKit

final class AddUnregularViewController: UIViewController {
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
    
    private func configureCategoryToAdd() -> TrackerCategory? {
        guard let trackerTitle = nameTextField.text,
              let color = selectedColor,
              let emoji = selectedEmoji
        else {
            assertionFailure("Title text field is empty")
            dismiss(animated: true)
            return nil
        }
        
        let newTracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: color,
            emoji: emoji,
            schedule: []
        )
        
        let categoryToAdd = TrackerCategory(
            title: selectedCategory,
            trackers: [newTracker]
        )
        
        return categoryToAdd
    }
    
    //MARK: - UI Updates
    private func toggleAddButton() {
        guard let trackerTitle = nameTextField.text
        else { return }
        
        let isValidName = trackerTitle.count < Constants.symbolLimit && trackerTitle.count != 0
        let isCategorySelected = selectedCategory != ""
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        
        updateCreateButtonState(
            name: isValidName,
            category: isCategorySelected,
            emoji: isEmojiSelected,
            color: isColorSelected
        )
        
        if !isValidName && trackerTitle.count != 0 {
            showWarning(with: "Ограничение  \(Constants.symbolLimit) символов")
            return
        } else {
            hideWarning()
        }
    }
    
    private func updateCreateButtonState(
        name isValidName: Bool,
        category isCategorySelected: Bool,
        emoji isEmojiSelected: Bool,
        color isColorSelected: Bool ) {
            let canEnableButton = isValidName && isCategorySelected && isEmojiSelected && isColorSelected
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

//MARK: - Category Selection Delegate
extension AddUnregularViewController: CategorySelectionDelegate {
    func selectCategory(_ category: String) {
        selectedCategory = category
        categorySelection.setSelectedCategory(selectedCategory)
        toggleAddButton()
    }
}

//MARK: - Text Field Delegate
extension AddUnregularViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Collection View Data Source
extension AddUnregularViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        configureCell(in: collectionView, at: indexPath)
    }
}

//MARK: - Collection View Delegate
extension AddUnregularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let side = CGFloat(view.bounds.height < 600 ? Constants.emojiColorCellSizeSmall : Constants.emojiColorCellSizeBig)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        view.bounds.height < 600 ? 0 : 5
    }
}
extension AddUnregularViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellToggle(toSelect: true, collectionView, at: indexPath)
        toggleAddButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        cellToggle(toSelect: false, collectionView, at: indexPath)
    }
}

//MARK: - Setup View
private extension AddUnregularViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(titleLabel, buttons, scrollView)

        setupScrollView()
        setupVStack()
        setupCategorySelection()
        setupEmojiCollectionView()
        setupColorCollectionView()
        setupConstraints()
    }
    
    func setupVStack() {
        vStackNameTextField.addArrangedSubviews(
            nameTextField, symbolLimitWarningLabel
        )
        stackContentView.addArrangedSubviews(vStackNameTextField)
    }
    
    func setupCategorySelection() {
        stackContentView.addArrangedSubviews(categorySelection)
    }
    
    func setupEmojiCollectionView() {
        stackContentView.setCustomSpacing(32, after: categorySelection)
        stackContentView.addArrangedSubviews(emojiTitle, emojiCollectionView)
    }
    
    func setupColorCollectionView() {
        stackContentView.setCustomSpacing(40, after: emojiCollectionView)
        stackContentView.addArrangedSubviews(colorTitle, colorCollectionView)
    }
    
    func setupScrollView() {
        scrollView.addSubviews(stackContentView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            vStackNameTextField.topAnchor.constraint(equalTo: stackContentView.topAnchor),
            vStackNameTextField.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            vStackNameTextField.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            vStackNameTextField.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: vStackNameTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: vStackNameTextField.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: vStackNameTextField.topAnchor),
            
            buttons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categorySelection.heightAnchor.constraint(equalToConstant: 75),
            categorySelection.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            categorySelection.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            categorySelection.topAnchor.constraint(equalTo: vStackNameTextField.bottomAnchor, constant: 24),
            
            emojiTitle.topAnchor.constraint(equalTo: categorySelection.bottomAnchor, constant: 60),
            emojiTitle.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor, constant: 12),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: Constants.emojiColorCellSizeBig * 3),
            
            colorTitle.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            colorTitle.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor, constant: 12),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 24),
            colorCollectionView.heightAnchor.constraint(equalToConstant: Constants.emojiColorCellSizeBig * 3),

            colorCollectionView.leadingAnchor.constraint(equalTo: stackContentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: stackContentView.trailingAnchor),
            
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

