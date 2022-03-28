//
//  OnboardingViewController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension OnboardingViewController {
    
    func inject(_ state: OnboardingState?) {
        self.state = state
    }
}

class OnboardingViewController: UIViewController {
    
    enum Action {
        case skip, finish
    }

    private weak var state: OnboardingState?
    
    private var action: ((Action) -> Void)?
    
    var containerController: ContainerViewController!
    private var containerView: UIView!
    
    private var currentPage: Int = 0 {
        didSet {
            updateControls()
        }
    }
    
    lazy var genderVC = GenderSelectionViewController().with {
        $0.inject(state)
        $0.onGenderChanged { [weak self] in
            self?.state?.gender = $0
            self?.continue()
        }
    }
    lazy var birthdayVC = BirthdaySelectionViewController().with {
        $0.initiallySelectedYear = state?.birthYear
        $0.onYearSelected { [weak self] in
            self?.state?.birthYear = $0
        }
    }
    
    lazy var interestsVC = InterestsViewController().with {
        $0.inject(state)
        $0.onInterestsSelectionDidChange { [weak self] (index, isSelected) in
            if isSelected {
                self?.state?.selectedInterests.append(index)
            } else {
                self?.state?.selectedInterests.removeAll(where: {
                    $0 == index
                })
            }
        }
    }
    
    lazy var skipButton = UIButton(type: .custom).with {
        $0.setTitle(L10n.skip, for: [])
        $0.setTitleColor(.tbxBlackTint, for: .normal)
        $0.titleLabel?.font = .light(ofSize: 14)
        $0.onAction { [weak self] _ in
            self?.action?(.skip)
        }
    }
    
    lazy var pageControl = PageControl()
    
    lazy var continueButton = UIButton(type: .custom).with {
        $0.isEnabled = false
        $0.isHidden = true
        $0.setTitle(L10n.continue, for: [])
        $0.titleLabel?.font = .semibold(ofSize: 14)
        $0.contentHorizontalAlignment = .center
        $0.setBackgroundImage(.fromColor(.tbxMainTint), for: .normal)
        $0.setBackgroundImage(.fromColor(.tbxVeryLightPink), for: .disabled)
        $0.xt.round(cornerRadius: 4.0)
        $0.onAction { [weak self] _ in
            self?.continue()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func onAction(_ closure: ((Action) -> Void)?) {
        action = closure
    }
}

extension OnboardingViewController {
    
    private func configure() {
        
        addStateObserver()
        
        view.backgroundColor = .tbxWhite
        
        let pages: [UIViewController] = [
            genderVC, birthdayVC, interestsVC
        ]
        pageControl.numberOfPages = pages.count
        
        containerController = ContainerViewController().with {
            
            addChild($0)
            containerView = $0.view
            view.addSubview(containerView)
            $0.didMove(toParent: self)
            $0.viewControllers = pages
            $0.onDidChange { [unowned self] in
                switch $0 {
                case let .didChangePosition(page): self.currentPage = page
                default: break
                }
            }
            $0.shouldScroll { [unowned self] (_, index) in
                switch pages[index] {
                case is GenderSelectionViewController:
                    return self.state?.isValidGender ?? false

                case is BirthdaySelectionViewController:
                    return self.state?.isValidBirthYear ?? false

                default: return true
                }
            }
        }
        
        view.xt.addSubviews(
            skipButton,
            containerView,
            pageControl,
            continueButton
        )
        
        containerView.xt.layout {
            $0.top(to: skipButton.xt.bottom)
            $0.leading(to: $1.xt.leading)
            $0.trailing(to: $1.xt.trailing)
            $0.bottom(-5, to: pageControl.xt.top)
        }
        
        skipButton.xt.layout {
            $0.top(to: safeAreaTopAnchor)
            $0.trailing(-16, to: $1.xt.trailing)
            $0.height(44)
        }
        
        continueButton.xt.layout {
            $0.centerX(equalTo: $1)
            $0.bottom(-23, to: safeAreaBottomAnchor)
            $0.width(equalTo: $1, multiplier: 0.54)
            $0.height(44.0)
        }
        
        pageControl.xt.layout {
            $0.centerX(equalTo: $1)
            $0.bottom(-12, to: continueButton.xt.top)
            $0.height(20)
        }
    }
    
    private func addStateObserver() {
        state?.onChange { [weak self] in
            switch $0 {
            case .changedData:
                self?.updateControls()
            case .startedLoading:
                self?.interestsVC.spinner.start()
            case .finishedLoading:
                self?.interestsVC.spinner.stop()
                self?.interestsVC.collectionView.reloadData()
            default: break
            }
        }
    }
    
    private func `continue`(after interval: TimeInterval = 0.25) {
        let isNotLastPage = currentPage < pageControl.numberOfPages - 1
        
        guard isNotLastPage else {
            action?(.finish)
            return
        }
        
        delay(interval) {
            self.containerController.switchToChild(
                withIndex: self.currentPage + 1,
                animated: true
            )
        }
    }
    
    private func updateControls() {
        pageControl.currentPage = currentPage
        continueButton.apply {
            let isLastPage = currentPage >= pageControl.numberOfPages - 1
            $0.isHidden = currentPage == 0
            $0.setTitle(isLastPage ? L10n.finish : L10n.continue, for: [])
            
            switch containerController.viewControllers[currentPage] {
            case is BirthdaySelectionViewController:
                $0.isEnabled = state?.isValidBirthYear ?? false
            case is InterestsViewController:
                $0.isEnabled = state?.isValidToFinish ?? false
            default: $0.isEnabled = false
            }
        }
    }
}
