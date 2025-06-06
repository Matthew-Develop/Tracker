//
//  EmojiCollectionCell.swift
//  Tracker
//
//  Created by Matthew on 11.05.2025.
//

import UIKit

final class EmojiCollectionCell: UICollectionViewCell {
    //Views
    let emojiImageView = UIImageView()
    
    //MARK: - Properties
    static let reuseIdentifier = "EmojiCollectionCell"
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Updates
    func selectCell() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = .ypLightGray
            self.emojiImageView.bounds.size.width += 10
        }
    }
    
    func deselectCell() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = .clear
        }
    }
}

//MARK: - Setup View
private extension EmojiCollectionCell {
    func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        isUserInteractionEnabled = true
        emojiImageView.isUserInteractionEnabled = true
        addSubviews(emojiImageView)
        NSLayoutConstraint.activate([
            emojiImageView.widthAnchor.constraint(equalToConstant: 52),
            emojiImageView.heightAnchor.constraint(equalToConstant: 52),
            emojiImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
