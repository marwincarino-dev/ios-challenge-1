//
//  MainViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var pageContainerView: UIView!
    
    // MARK: - Properties
    
    var viewModel: MainViewModel!
    
    private var pageViewController: UIPageViewController!
    private var pageViewControllers: [UIViewController] = []
    private var currentPageController: UIViewController?
    private var currentPageIndex: Int = 0
    
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
    
    // MARK: - IBActions
    
    @IBAction private func onTapClose(_ sender: Any) {
        showAlert(title: nil, message: "No implementation")
    }
    
    @IBAction private func onTapBack(_ sender: Any) {
        previousScreen()
    }
}

private extension MainViewController {
    func loadData() {
        Task {
            do {
                try await viewModel.loadScreens()
                setupPageScreens()
                updateProgressView()
                updateBackButton()
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
                controller.onSubmit = handleScreenOnSubmit()
                
                pageViewControllers.append(controller)
            } else if let recapVM = screenVM as? RecapViewModel {
                let controller = RecapViewController.make()
                controller.viewModel = recapVM
                controller.onSubmit = handleScreenOnSubmit()
                
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
        
        let firstIndex = 0
        let firstController = pageViewControllers[firstIndex]
        
        updatePageStates(
            viewController: firstController,
            index: firstIndex,
            direction: .forward
        )
    }
    
    func nextScreen() {
        guard let currentPageController,
              let currentIndex = pageViewControllers.firstIndex(of: currentPageController),
              (currentIndex + 1) < pageViewControllers.count else { return }
        
        let nextIndex = currentIndex + 1
        let nextController = pageViewControllers[nextIndex]
        
        updatePageStates(
            viewController: nextController,
            index: nextIndex,
            direction: .forward
        )
    }
    
    func previousScreen() {
        guard let currentPageController,
              let currentIndex = pageViewControllers.firstIndex(of: currentPageController),
              (currentIndex - 1) >= 0 else { return }
        
        let previousIndex = currentIndex - 1
        let previousController = pageViewControllers[previousIndex]
        
        updatePageStates(
            viewController: previousController,
            index: previousIndex,
            direction: .reverse
        )
    }
    
    func updatePageStates(viewController: UIViewController, index: Int, direction: UIPageViewController.NavigationDirection) {
        currentPageController = viewController
        currentPageIndex = index
        
        pageViewController.setViewControllers(
            [currentPageController!],
            direction: direction,
            animated: true
        )
        
        updateProgressView()
        updateBackButton()
    }
}

private extension MainViewController {
    func updateProgressView() {
        let currentProgress = Float(Float(currentPageIndex) / Float(pageViewControllers.count - 1))
        progressView.setProgress(currentProgress, animated: true)
    }
    
    func updateBackButton() {
        backButton.isHidden = currentPageIndex <= 0
    }
}

private extension MainViewController {
    func handleScreenOnSubmit() -> (() -> Void) {
        return { [weak self] in
            guard let self else { return }
            
            self.nextScreen()
        }
    }
}
