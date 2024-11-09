//
//  MainViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class MainViewController: UIViewController {
    private var pageViewController: UIPageViewController!
    private var pageViewControllers: [UIViewController] = []
    
    @IBOutlet var pageContainerView: UIView!
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
}

private extension MainViewController {
    func loadData() {
        Task {
            do {
                try await viewModel.loadActivityContainer()
            } catch {
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

private extension MainViewController {
    var item: ActivityContainer? {
        viewModel.item
    }
}

// MARK: - Page

private extension MainViewController {
    func setupPageContent() {
        setupPageViewControllers()
        setupPageViewController()
    }
    
    func setupPageViewControllers() {
        pageViewControllers = [
            MultipleChoiceViewController.make(),
            RecapViewController.make(),
            MultipleChoiceViewController.make(),
        ]
    }
    
    func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: [:]
        )
        
        addChild(pageViewController)
        pageViewController.view.frame = pageContainerView.bounds
        pageContainerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstPage = pageViewControllers.first {
            pageViewController.setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true
            )
        }
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let currentIndex = pageViewControllers.firstIndex(of: viewController),
              currentIndex > 0 else {
            return nil
        }
        
        return pageViewControllers[currentIndex - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pageViewControllers.firstIndex(of: viewController),
              currentIndex < pageViewControllers.count - 1 else {
            return nil
        }
        
        return pageViewControllers[currentIndex + 1]
    }
}

extension MainViewController {
    static func make() -> MainViewController {
        return UIStoryboard.main.instantiateViewController(ofType: MainViewController.self)
    }
}
