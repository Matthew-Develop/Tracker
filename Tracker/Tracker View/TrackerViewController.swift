//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Matthew on 21.04.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    //MARK: Views
    private var addTrackerButton = UIButton(type: .system)
    private var datePicker = UIDatePicker()
    private var topBarTitle = UILabel()
    private var searchField = UISearchTextField()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Properties
    var currentDate: Date = Date()
    var currentDayOfWeek: String = "unknown"
    var categories: [TrackerCategory] = MockData().categories
    var completedTrackers: [TrackerRecord] = []
    var visibleTrackers: [TrackerCategory] = []
    
    //MARK: -Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setDayOfWeek()
        setVisibleTrackers()
    }
    
    //MARK: Private Functions
    @objc private func addTrackerButtonTapped(_ sender: UIButton) {
        let navigationController = UINavigationController(rootViewController: AddTrackerViewController())
        
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true)
    }
    
    @objc private func dateValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        setDayOfWeek()
        setVisibleTrackers()
        print("Выбранная дата: \(formattedDate). Это \(currentDayOfWeek)")
        
        NotificationCenter.default
            .post(
                name: NSNotification.Name("DateChanged"),
                object: self,
                userInfo: ["currentDate": currentDate]
            )
        
        collectionView.reloadData()
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
            id: tracker.id
        )
    }
    
    private func setDayOfWeek() {
        guard let dayNumberOfWeek = currentDate.dayNumberOfWeek()
        else { return }
        
        currentDayOfWeek = dayNumberOfWeek.whatDayOfWeek()
    }
    
    private func setVisibleTrackers() {
        var visible: [TrackerCategory] = []
        
        for category in categories {
            var trackers: [Tracker] = []
            
            for tracker in category.trackers {
                if tracker.schedule.isEmpty {
                    trackers.append(tracker)
                } else if tracker.schedule.contains(currentDayOfWeek) {
                    trackers.append(tracker)
                }
            }
            
            if !trackers.isEmpty {
                let tempCat = TrackerCategory(title: category.title, trackers: trackers)
                visible.append(tempCat)
            }
            
            trackers = []
        }
        
        if !visible.isEmpty {
            visibleTrackers = visible
        }
    }
}

//Setup View
extension TrackerViewController {
    private func setupView() {
        view.backgroundColor = .ypWhite
        
        setupAddTrackerButton()
        setupDatePicker()
        setupSearchField()
//        setupIfEmptyTrackers()
        setupNavigationBar()
        setupCollectionView()
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
        searchField.textColor = .ypGray
        searchField.placeholder = "Поиск"
        searchField.font = .systemFont(ofSize: 17, weight: .regular)
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    private func setupIfEmptyTrackers() {
        let image = UIImageView()
        image.autoResizeOff()
        image.image = UIImage(named: "IfEmptyTrackers")
        
        let textLabel = UILabel()
        textLabel.autoResizeOff()
        textLabel.text = "Что будем отслеживать?"
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .ypBlack
        
        view.addSubview(image)
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),
            
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: view.bounds.height * 0.25),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)
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
        return CGSize(width: (view.frame.width - 32 - 9) / 2, height: 148)
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
