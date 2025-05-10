//
//  ScheduleSelectionViewController.swift
//  Tracker
//
//  Created by Matthew on 04.05.2025.
//

import UIKit

protocol ScheduleSelectionViewControllerDelegate: AnyObject {
    func selectSchedule(_ schedule: [String])
}

final class ScheduleSelectionViewController: UIViewController {
    //MARK: Views
    private let titleLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    private let tableView = UITableView()
    
    //MARK: - Properties
    weak var delegate: ScheduleSelectionViewControllerDelegate?
    var selectedSchedule: [String: Bool] = [ "Пн": false, "Вт": false, "Ср": false, "Чт": false, "Пт": false, "Сб": false, "Вс": false ]

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Private Functions
    @objc private func doneButtonTapped(_ sender: UIButton) {
        delegate?.selectSchedule(convertScheduleDictToArray())
        dismiss(animated: true)
    }
    
    private func configureCell(cell: ScheduleSelectionCell, for indexPath: IndexPath) {
        cell.getDayOfWeek(for: indexPath)
        let day = cell.day ?? "unknown"
        cell.switchView.isOn = selectedSchedule[day] ?? false
        
        if indexPath.row == 6 {
            cell.bottomLine.isHidden = true
            cell.setDownCellCorners()
        } else if indexPath.row == 0 {
            cell.setUpCellCorners()
        }
    }
    
    private func convertScheduleDictToArray() -> [String] {
        var arrayOfDays: [String] = []
        
        for (key, value) in selectedSchedule {
            if value == true {
                arrayOfDays.append(key)
            }
        }
        
        return arrayOfDays.sortedDays()
    }
}

extension ScheduleSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleSelectionCell.reuseIdentifier, for: indexPath) as? ScheduleSelectionCell
        else { return UITableViewCell() }
        
        configureCell(cell: cell, for: indexPath)
        cell.delegate = self
        
        return cell
    }
}

extension ScheduleSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension ScheduleSelectionViewController: ScheduleSelectionCellDelegate {
    func addDayToSchedule(_ day: String) {
        selectedSchedule[day] = true
    }
    
    func removeDayFromSchedule(_ day: String) {
        selectedSchedule[day] = false
    }
}

//Setup View
private extension ScheduleSelectionViewController {
    func setupView() {
        view.backgroundColor = .ypWhite
        
        addViewTitle()
        addDoneButton()
        addTableView()
    }
    
    func addViewTitle() {
        titleLabel.autoResizeOff()
        
        titleLabel.text = "Расписание"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ypBlack
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addTableView() {
        tableView.autoResizeOff()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleSelectionCell.self, forCellReuseIdentifier: ScheduleSelectionCell.reuseIdentifier)
        
        tableView.contentInset.top = 24
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -14)

        ])
    }
    
    func addDoneButton() {
        doneButton.autoResizeOff()
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.ypWhite, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.backgroundColor = .ypBlack
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
