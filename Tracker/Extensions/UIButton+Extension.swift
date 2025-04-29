//
//  UIButton+Extension.swift
//  Tracker
//
//  Created by Matthew on 28.04.2025.
//

import UIKit

extension UIButton {
    func backgroundOff() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
        }
    }
    
    func backgroundOn() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
        }
    }
}
