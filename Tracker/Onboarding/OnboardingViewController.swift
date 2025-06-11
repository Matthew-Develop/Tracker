//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Matthew on 31.05.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    //MARK: - Views
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypBlack
        button.setTitle(L10n.Onboarding.button, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhite
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    lazy var pages: [UIViewController] = {
        let vc1 = makePageViewController("onboarding_1", text: L10n.Onboarding.Vc1.title)
        let vc2 = makePageViewController("onboarding_2", text: L10n.Onboarding.Vc2.title)
        
        return [vc1, vc2]
    }()
    private let userDefaultsService = UserDefaultsService.shared
    
    //MARK: - Lifecycle
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupView()
    }
    
    //MARK: - Private Functions
    @objc private func didTapButton(_ sender: UIButton) {
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
        
        userDefaultsService.isOnboardingSkipped = true
    }
}

//MARK: - PageController DataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexVC = pages.firstIndex(of: viewController) else {return nil }
        let indexBefore = indexVC - 1
        guard indexBefore >= 0 else { return nil }
        return pages[indexBefore]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let indexVC = pages.firstIndex(of: viewController) else {return nil }
        let indexAfter = indexVC + 1
        guard indexAfter < pages.count else { return nil }
        return pages[indexAfter]
    }
}

//MARK: - PageController Delegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let indexVC = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = indexVC
        }
    }
}

//MARK: Setup Viewcontrollers
private extension OnboardingViewController {
    func makePageViewController(_ imageName: String, text: String) -> UIViewController {
        let vc = UIViewController()
        let image: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: imageName)
            return image
        }()
        let textLabel: UILabel = {
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: 32, weight: .bold)
            label.textColor = .black
            label.numberOfLines = 3
            label.textAlignment = .center
            return label
        }()
        
        vc.view.addSubviews(image, textLabel)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            image.topAnchor.constraint(equalTo: vc.view.topAnchor),
            image.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -1*view.bounds.height*0.34)
        ])
        
        return vc
    }
    
    func setupView() {
        view.addSubviews(pageControl, nextButton)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
}
