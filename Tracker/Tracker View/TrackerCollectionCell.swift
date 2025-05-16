//
//  TrackerCollectionCell.swift
//  Tracker
//
//  Created by Matthew on 27.04.2025.
//

import UIKit

protocol TrackerCollectionCellDelegate: AnyObject {
    func addTrackerRecord(to id: UUID, at date: Date)
    func removeTrackerRecord(to id: UUID, at date: Date)
}

final class TrackerCollectionCell: UICollectionViewCell {
    //MARK: Views
    private var cardView = UIView()
    private var emojiView = UIImageView()
    private var titleLabel = UILabel()
    private var countLabel = UILabel()
    private var completeTrackerButton = UIButton(type: .system)
    
    //MARK: - Properties
    static let reuseIdentifier: String = "TrackerCollectionCell"
    weak var delegate: TrackerCollectionCellDelegate?
    
    var id: UUID = UUID()
    var isCompleted: Bool = false
    var currentCount: Int = 0
    var currentDate: Date = Date()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Functions
    func setTrackerData(
        color: UIColor,
        emoji: UIImage,
        title: String,
        count: Int,
        isCompleted: Bool,
        id: UUID,
        date: Date ) {
            cardView.backgroundColor = color
            emojiView.image = emoji
            titleLabel.text = title
            countLabel.text = counterDayCorrection(count)
            completeTrackerButton.backgroundColor = color
            
            self.isCompleted = isCompleted
            self.currentCount = count
            self.id = id
            self.currentDate = date
            
            changeButtonEnabled()
            changeButtonStatus(toComplete: isCompleted)
        }
    
    //MARK: - Private Functions
    @objc private func completeTrackerButtonTapped(_ sender: UIButton) {
        changeButtonStatus(toComplete: !isCompleted)
        updateCount(toAdd: !isCompleted)
        isCompleted = !isCompleted
    }
    
    private func changeButtonStatus(toComplete: Bool) {
        if toComplete {
            completeTrackerButton.setImage(UIImage(named: "DoneTrackerButton"), for: .normal)
            completeTrackerButton.backgroundOff()
            
        } else {
            completeTrackerButton.setImage(UIImage(named: "CompleteTrackerButton"), for: .normal)
            completeTrackerButton.backgroundOn()
        }
    }
    
    private func changeButtonEnabled() {
        if currentDate > Date() {
            completeTrackerButton.isEnabled = false
            if !isCompleted { completeTrackerButton.backgroundOff() }
        } else {
            completeTrackerButton.isEnabled = true
        }
    }
    
    private func updateCount(toAdd: Bool) {
        if toAdd {
            countLabel.text = counterDayCorrection(currentCount + 1)
            currentCount += 1
            
            delegate?.addTrackerRecord(to: id, at: currentDate)
        } else if currentCount > 0 {
            countLabel.text = counterDayCorrection(currentCount - 1)
            currentCount -= 1
            
            delegate?.removeTrackerRecord(to: id, at: currentDate)
        }
    }
    
    private func counterDayCorrection(_ count: Int) -> String {
        var countString = ""
        let lastNumber = count.description.last
        let lastTwoNumber = (count % 100).description
        
        if count > 10 {
            if ["11","12","13","14","15","16","17","18","19"].contains(lastTwoNumber) {
                
                 return "\(count.description) дней"
            }
        }
            
        if lastNumber == "1" {
            countString = "\(count.description) день"
            
        } else if ["0","5","6","7","8","9"].contains(lastNumber) {
            countString = "\(count.description) дней"
            
        } else {
            countString = "\(count.description) дня"
        }
        
        return countString
    }
}

//Setup View
private extension TrackerCollectionCell {
    func setupView() {
        setupCardView()
        setupCountLabel()
        setupCompleteTrackerButton()
    }
    
    func setupCardView() {
        cardView.autoResizeOff()
        
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        
        addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        setupEmojiView()
        setupTitleLabel()
    }
    
    func setupEmojiView() {
        emojiView.backgroundColor = .white.withAlphaComponent(0.3)
        emojiView.layer.cornerRadius = 12
        emojiView.layer.masksToBounds = true
        
        cardView.addSubviews(emojiView)
        NSLayoutConstraint.activate([
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.autoResizeOff()
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        cardView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    func setupCountLabel() {
        countLabel.autoResizeOff()
        
        countLabel.font = .systemFont(ofSize: 12, weight: .medium)
        countLabel.textColor = .ypBlack
        
        addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16)
        ])
    }
    
    func setupCompleteTrackerButton() {
        completeTrackerButton.autoResizeOff()
        
        completeTrackerButton.addTarget(self, action: #selector(completeTrackerButtonTapped), for: .touchUpInside)
        
        completeTrackerButton.tintColor = .white
        completeTrackerButton.layer.cornerRadius = 17
        completeTrackerButton.layer.masksToBounds = true
        
        addSubview(completeTrackerButton)
        NSLayoutConstraint.activate([
            completeTrackerButton.widthAnchor.constraint(equalToConstant: 34),
            completeTrackerButton.heightAnchor.constraint(equalToConstant: 34),

            completeTrackerButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeTrackerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
