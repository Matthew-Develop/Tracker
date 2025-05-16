//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Matthew on 21.04.2025.
//

import UIKit
import CoreData

final class TrackerViewController: UIViewController {
    //MARK: Views
    private var addTrackerButton = UIButton(type: .system)
    private var datePicker = UIDatePicker()
    private var topBarTitle = UILabel()
    private var searchField = UISearchTextField()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var emptyTextLabel = UILabel()
    private var emptyImageView = UIImageView()
    
    //MARK: - Properties
    var currentDate: Date = Date()
    var currentDayOfWeek: String = "unknown"
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var visibleTrackers: [TrackerCategory] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToHideKeyboard()
        
        categories = MockData().categories
        
        setupView()
        setCurrentDate()
        setDayOfWeek()
        reloadVisibleTrackers()
    }
    
    //MARK: - Private Functions
    @objc private func addTrackerButtonTapped(_ sender: UIButton) {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.mainVC = self
        
        let navigationController = UINavigationController(rootViewController: addTrackerViewController)
        
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true)
    }
    
    @objc private func dateValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        
        setCurrentDate()
        setDayOfWeek()
        reloadVisibleTrackers()
        print("Выбранная дата: \(currentDate). Это \(currentDayOfWeek)")
    }
    
    @objc private func searchFieldValueChanged(_ sender: UISearchTextField) {
        reloadVisibleTrackers()
    }
    
    private func configureCell(cell: TrackerCollectionCell, indexPath: IndexPath) {
        let tracker = visibleTrackers[indexPath.section].trackers[indexPath.row]
        let count = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompleted = !completedTrackers.filter {
            $0 == TrackerRecord(trackerId: tracker.id, completeDate: currentDate)
        }.isEmpty
        
        cell.setTrackerData(
            color: tracker.color,
            emoji: tracker.emoji,
            title: tracker.title,
            count: count,
            isCompleted: isCompleted,
            id: tracker.id,
            date: currentDate
        )
    }
    
    private func setCurrentDate() {
        guard let correctedDate = currentDate.correctedDate() else { return }
        currentDate = correctedDate
    }
    
    private func setDayOfWeek() {
        guard let dayNumberOfWeek = currentDate.dayNumberOfWeek()
        else { return }
        
        currentDayOfWeek = dayNumberOfWeek.whatDayOfWeek()
    }
    
    private func reloadVisibleTrackers() {
        let searchText = (searchField.text ?? "").lowercased()
        
        visibleTrackers = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let dateCondition = tracker.schedule.contains(currentDayOfWeek)
                let searchCondition = searchText.isEmpty || tracker.title.lowercased().contains(searchText)
                
                return dateCondition && searchCondition
            }
            
            if trackers.isEmpty { return nil }
            
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        
        reloadIfEmptyView()
        collectionView.reloadData()
    }
    
    private func reloadIfEmptyView() {
        emptyImageView.isHidden = !visibleTrackers.isEmpty
        emptyTextLabel.isHidden = !visibleTrackers.isEmpty
        collectionView.isHidden = visibleTrackers.isEmpty
    }
}

//AddTrackerDelegate
extension TrackerViewController: AddHabitViewControllerDelegate {
    func addNewHabit(category: TrackerCategory) {
        
        let tempCategories = categories
        var tempCategoryTrackers = category.trackers
        var result: [TrackerCategory] = []
        
        if tempCategories.filter({ $0.title == category.title }).isEmpty  {
            
            let newCategory = TrackerCategory(title: category.title, trackers: tempCategoryTrackers)
            
            result = [newCategory] + tempCategories
        } else {
            for item in tempCategories {
                if item.title == category.title {
                    tempCategoryTrackers += item.trackers
                    
                    let updatedCategory = TrackerCategory(title: item.title, trackers: tempCategoryTrackers)
                    
                    result.append(updatedCategory)
                } else {
                    result.append(item)
                }
            }
        }
        
        categories = result
        reloadVisibleTrackers()
    }
}

//Cell Delegate
extension TrackerViewController: TrackerCollectionCellDelegate {
    func addTrackerRecord(to id: UUID, at date: Date) {
        completedTrackers.append(TrackerRecord(
            trackerId: id,
            completeDate: date))
    }
    
    func removeTrackerRecord(to id: UUID, at date: Date) {
        var records = completedTrackers
        records.removeAll { $0.trackerId == id && $0.completeDate == date }
        completedTrackers = records
    }
}

//Search Field delegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleTrackers()
        return true
    }
}

//Collection View Data Source and DelegateFlowLayout
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionCell.reuseIdentifier, for: indexPath) as? TrackerCollectionCell
        else { return UICollectionViewCell() }
        
        configureCell(cell: cell, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeaderCollectionView
        else { return UICollectionReusableView() }
        
        view.titleLabel.text = visibleTrackers[indexPath.section].title
        
        return view
    }
}
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.width - 32 - 9) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return sizeForHeaderSection(text: visibleTrackers[section].title, width: view.frame.width)
    }
    
    private func sizeForHeaderSection(text: String, width: CGFloat) -> CGSize {
        let tempView = SectionHeaderCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        tempView.titleLabel.text = text
        
        let targetSize = CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)
        return tempView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

//Setup View
extension TrackerViewController {
    private func setupView() {
        view.backgroundColor = .ypWhite
        
        setupAddTrackerButton()
        setupDatePicker()
        setupSearchField()
        setupNavigationBar()
        setupCollectionView()
        setupIfEmptyTrackers()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .ypWhite
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.ypBlack]
    }
    
    private func setupAddTrackerButton() {
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)

        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonTapped), for: .touchUpInside)
        addTrackerButton.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        addTrackerButton.tintColor = .ypBlack
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.tintColor = .ypBlue
        datePicker.date = Date()
        
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    private func setupSearchField() {
        
        searchField.autoResizeOff()
        
        searchField.backgroundColor = .ypSearchField
        searchField.textColor = .ypBlack
        searchField.placeholder = "Поиск"
        searchField.font = .systemFont(ofSize: 17, weight: .regular)
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        
        searchField.addTarget(self, action: #selector(searchFieldValueChanged), for: .editingChanged)
        searchField.delegate = self
        
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    private func setupIfEmptyTrackers() {
        emptyImageView.autoResizeOff()
        emptyImageView.image = UIImage(named: "IfEmptyTrackers")
        
        emptyTextLabel.autoResizeOff()
        emptyTextLabel.text = "Что будем отслеживать?"
        emptyTextLabel.font = .systemFont(ofSize: 12, weight: .medium)
        emptyTextLabel.textColor = .ypBlack
        
        view.addSubview(emptyImageView)
        view.addSubview(emptyTextLabel)
        NSLayoutConstraint.activate([
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: view.bounds.height * 0.25),
            
            emptyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTextLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.autoResizeOff()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCollectionCell.self, forCellWithReuseIdentifier: TrackerCollectionCell.reuseIdentifier)
        collectionView.register(SectionHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = 24
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
