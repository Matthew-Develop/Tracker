//
//  ScheduleSelectionCell.swift
//  Tracker
//
//  Created by Matthew on 04.05.2025.
//

import UIKit

protocol ScheduleSelectionCellDelegate: AnyObject {
    func addDayToSchedule(_ day: String)
    func removeDayFromSchedule(_ day: String)
}

final class ScheduleSelectionCell: UITableViewCell {
    //MARK: Views
    let dayLabel = UILabel()
    let switchView = UISwitch(frame: .zero)
    let bottomLine = UIView()
    
    //MARK: - Properties
    static let reuseIdentifier = "ScheduleSelectionCell"
    weak var delegate: ScheduleSelectionCellDelegate?
    var day: String?
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Functions
    @objc private func switchToggled(_ sender: UISwitch) {
        guard let day else { return }
        
        sender.isOn
            ? delegate?.addDayToSchedule(day)
            : delegate?.removeDayFromSchedule(day)
    }
    
    //MARK: - Public Functions
    func getDayOfWeek(for indexPath: IndexPath) {
        let dayNumber = indexPath.row + 1
        
        switch dayNumber {
        case 1:
            dayLabel.text = "Понедельник"
            day = "Пн"
        case 2:
            dayLabel.text = "Вторник"
            day = "Вт"
        case 3:
            dayLabel.text = "Среда"
            day = "Ср"
        case 4:
            dayLabel.text = "Четверг"
            day = "Чт"
        case 5:
            dayLabel.text = "Пятница"
            day = "Пт"
        case 6:
            dayLabel.text = "Суббота"
            day = "Сб"
        case 7:
            dayLabel.text = "Воскресенье"
            day = "Вс"
        default:
            dayLabel.text = ""
            day = nil
        }
    }
    
    func setUpCellCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setDownCellCorners() {
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

//MARK: - Setup View
private extension ScheduleSelectionCell {
    func setupView() {
        
        backgroundColor = .ypBackground
        
        addDayLabel()
        addSwitchView()
        addBottomLine()
    }
    
    func addDayLabel() {
        dayLabel.autoResizeOff()
        
        addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addSwitchView() {
        switchView.autoResizeOff()
        
        switchView.onTintColor = .ypBlue
        switchView.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        
        contentView.addSubview(switchView)
        NSLayoutConstraint.activate([
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func addBottomLine() {
        bottomLine.autoResizeOff()
        
        bottomLine.backgroundColor = .ypGray
        
        addSubview(bottomLine)
        NSLayoutConstraint.activate([
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
