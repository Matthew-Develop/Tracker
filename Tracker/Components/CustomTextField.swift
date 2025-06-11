//
//  CustomAddTrackerNameTextField.swift
//  Tracker
//
//  Created by Matthew on 30.04.2025.
//

import UIKit

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePlaceholder(to text: String) {
        placeholder = text
    }
}

private extension CustomTextField {
    private func setupView() {
        
        self.autoResizeOff()
        
        placeholder = L10n.AddTrackerVC.trackerNamePlaceholder
        backgroundColor = .ypBackground
        textColor = .ypBlack
        leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        leftViewMode = .always
        rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        rightViewMode = .always
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
