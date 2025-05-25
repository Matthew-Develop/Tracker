//
//  SelectionArrays.swift
//  Tracker
//
//  Created by Matthew on 11.05.2025.
//

import UIKit

enum SelectionArrays {
    static let emojiArray: [UIImage] = (1...18).compactMap { UIImage(named: "Emoji-\($0)")}
    static let colorArray: [UIColor] = [
        .color1,.color2,.color3,.color4,.color5,.color6,
        .color7,.color8,.color9,.color10,.color11,.color12,
        .color13,.color14,.color15,.color16, .color17, .color18
    ]
}
