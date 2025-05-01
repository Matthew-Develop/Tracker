//
//  CustomCategoryAndScheduleSelection.swift
//  Tracker
//
//  Created by Matthew on 30.04.2025.
//

import UIKit

final class CustomCategoryAndScheduleSelection: UIStackView {
    //Views
    let categorySelectorView = UIView()
    let scheduleSelectorView = UIView()
    let selectedCategoryLabel = UILabel()
    let selectedScheduleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Functions
    func setSelectedCategory(_ text: String) {
        selectedCategoryLabel.isHidden = false
        selectedCategoryLabel.text = text
    }
    
    func setSelectedSchedule(_ text: String) {
        selectedScheduleLabel.isHidden = false
        selectedScheduleLabel.text = text
    }
}

private extension CustomCategoryAndScheduleSelection {
    func setupView() {
        
        self.autoResizeOff()
        
        spacing = 0
        axis = .vertical
        distribution = .fillEqually
        backgroundColor = .ypBackground
        addArrangedSubview(categorySelectorView)
        addArrangedSubview(scheduleSelectorView)
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        setupCategorySelectorView()
        setupScheduleSelectorView()
    }
    
    func setupCategorySelectorView() {
        let vStack = UIStackView()
        vStack.autoResizeOff()
        vStack.axis = .vertical
        vStack.spacing = 2
        
        selectedCategoryLabel.isHidden = true
        selectedCategoryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        selectedCategoryLabel.textColor = .ypGray
        
        let title = UILabel()
        title.autoResizeOff()
        title.text = "Категория"
        title.textColor = .ypBlack
        title.font = .systemFont(ofSize: 17, weight: .regular)
        
        let dividerView = UIView()
        dividerView.autoResizeOff()
        dividerView.backgroundColor = .ypGray
        
        let arrow = UIImageView()
        arrow.autoResizeOff()
        arrow.image = UIImage(named: "ArrowCategorySelector")
        
        vStack.addArrangedSubview(title)
        vStack.addArrangedSubview(selectedCategoryLabel)
        
        categorySelectorView.addSubview(vStack)
        categorySelectorView.addSubview(arrow)
        categorySelectorView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 24),
            arrow.heightAnchor.constraint(equalToConstant: 24),
            
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            vStack.leadingAnchor.constraint(equalTo: categorySelectorView.leadingAnchor, constant: 16),
            vStack.centerYAnchor.constraint(equalTo: categorySelectorView.centerYAnchor),
            
            arrow.trailingAnchor.constraint(equalTo: categorySelectorView.trailingAnchor, constant: -16),
            arrow.centerYAnchor.constraint(equalTo: categorySelectorView.centerYAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: categorySelectorView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: categorySelectorView.trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: categorySelectorView.bottomAnchor)
        ])
    }
    
    func setupScheduleSelectorView() {
        let vStack = UIStackView()
        vStack.autoResizeOff()
        vStack.axis = .vertical
        vStack.spacing = 2
        
        selectedScheduleLabel.isHidden = true
        selectedScheduleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        selectedScheduleLabel.textColor = .ypGray
        
        let title = UILabel()
        title.autoResizeOff()
        title.text = "Расписание"
        title.textColor = .ypBlack
        title.font = .systemFont(ofSize: 17, weight: .regular)
        
        let arrow = UIImageView()
        arrow.autoResizeOff()
        arrow.image = UIImage(named: "ArrowCategorySelector")
        
        vStack.addArrangedSubview(title)
        vStack.addArrangedSubview(selectedScheduleLabel)
        
        scheduleSelectorView.addSubview(vStack)
        scheduleSelectorView.addSubview(arrow)
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 24),
            arrow.heightAnchor.constraint(equalToConstant: 24),
            
            vStack.leadingAnchor.constraint(equalTo: scheduleSelectorView.leadingAnchor, constant: 16),
            vStack.centerYAnchor.constraint(equalTo: scheduleSelectorView.centerYAnchor),
            
            arrow.trailingAnchor.constraint(equalTo: scheduleSelectorView.trailingAnchor, constant: -16),
            arrow.centerYAnchor.constraint(equalTo: scheduleSelectorView.centerYAnchor),
        ])
    }
}
