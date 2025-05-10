//
//  UIView+Extension.swift
//  Tracker
//
//  Created by Matthew on 21.04.2025.
//

import UIKit

extension UIView {
    @discardableResult func edgesToSuperview() -> Self {
        guard let superview = superview else {
            assertionFailure("View не в иерархии!")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        return self
    }
    
    func autoResizeOff() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
