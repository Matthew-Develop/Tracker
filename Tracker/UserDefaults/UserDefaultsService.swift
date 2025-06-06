//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Matthew on 06.06.2025.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Key {
        static let onboardingSkipped = "onboardingSkipped"
    }
    
    var isOnboardingSkipped: Bool {
        get { defaults.bool(forKey: Key.onboardingSkipped) }
        set { defaults.set(newValue, forKey: Key.onboardingSkipped) }
    }
}
