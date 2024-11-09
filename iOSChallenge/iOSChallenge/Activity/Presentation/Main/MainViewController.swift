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
                try await viewModel.loadScreens()
                setupPageScreens()
            } catch {
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Page Screen

private extension MainViewController {
    func setupPageScreens() {
        setupPageViewControllers()
        setupPageViewController()
    }
    
    func setupPageViewControllers() {
        pageViewControllers = []
        
        viewModel.screenViewModels.forEach { screenVM in
            if let multipleChoiceVM = screenVM as? MultipleChoiceViewModel {
                let controller = MultipleChoiceViewController.make()
                controller.viewModel = multipleChoiceVM
                
                pageViewControllers.append(controller)
            } else if let recapVM = screenVM as? RecapViewModel {
                let controller = RecapViewController.make()
                controller.viewModel = recapVM
                
                pageViewControllers.append(controller)
            }
        }
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
