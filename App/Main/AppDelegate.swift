//
//  AppDelegate.swift
//  VFPoC
//
//  Created by Sergey Gorin on 04/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var onboardingState = OnboardingState()
    
    lazy var mainNC = UINavigationController(rootViewController: mainTabBarController).with {
        $0.isNavigationBarHidden = true
    }
    
    lazy var mainTabBarController = MainTabBarController().with {
        $0.navigationItem.clearBackButtonItem()
        $0.viewControllers = [feedVC, favoritesVC, cartVC, profileVC].map {
            UINavigationController(rootViewController: $0)
        }
    }
    
    lazy var onboardingVC = OnboardingViewController().with {
        $0.inject(onboardingState)
        $0.onAction { [weak self] in
            switch $0 {
            case .skip: UserDefaults.shouldSkipOnboarding = false
            case .finish: UserDefaults.isOnboardingFinished = true
            }
            self?.window?.rootViewController = self?.mainNC
        }
    }
    
    lazy var feedVC = VideoFeedController().with {
        $0.navigationItem.clearBackButtonItem()
        $0.title = L10n.TabBarItem.feed
        $0.tabBarItem = UITabBarController.Tab.feed.tabBarItem
        $0.inject(VideoFeedDataProvider())
    }
    
    lazy var favoritesVC = FavoritesViewController().with { vc in
        vc.navigationItem.clearBackButtonItem()
        vc.title = L10n.TabBarItem.favorites
        vc.tabBarItem = UITabBarController.Tab.favorites.tabBarItem
    }
    
    lazy var cartVC = CartViewController().with { vc in
        vc.navigationItem.clearBackButtonItem()
        vc.title = L10n.TabBarItem.cart
        vc.tabBarItem = UITabBarController.Tab.cart.tabBarItem
    }
    
    lazy var profileVC = ProfileViewController().with { vc in
        vc.navigationItem.clearBackButtonItem()
        vc.title = L10n.TabBarItem.profile
        vc.tabBarItem = UITabBarController.Tab.profile.tabBarItem
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        try? AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.ambient,
            mode: AVAudioSession.Mode.moviePlayback,
            options: [.mixWithOthers]
        )
        
        configureDefaultNavigationBarStyling()
        
        window = UIWindow(frame: UIScreen.main.bounds).with { w in
            w.backgroundColor = .white
            w.rootViewController = UserDefaults.shouldSkipOnboarding
                ? mainNC
                : onboardingVC
            
            w.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate {
    
    func configureDefaultNavigationBarStyling() {
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .tbxWhite
    }
}
