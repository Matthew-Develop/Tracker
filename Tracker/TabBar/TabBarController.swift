//
//  TabBarController.swift
//  Tracker
//
//  Created by Matthew on 21.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .ypWhite
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        
        tabBar.shadowImage = UIImage()
        tabBar.layer.shadowColor = UIColor.ypGray.cgColor
        tabBar.layer.shadowRadius = 0.5
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowOpacity = 1
        
        viewControllers = [setTrackerNavigationController(), setStatisticsViewController()]
    }
    
    private func setTrackerNavigationController() -> UINavigationController {
        let trackerVC = TrackerViewController()
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            tag: 1)
        
        return UINavigationController(rootViewController: trackerVC)
    }
    
    private func setStatisticsViewController() -> UIViewController{
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            tag: 2)
        
        return statisticsVC
    }
}
