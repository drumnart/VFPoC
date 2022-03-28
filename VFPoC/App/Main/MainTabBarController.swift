//
//  MainTabBarController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 15/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    enum Tab: Int {
        case feed
        case favorites
        case cart
        case profile
        
        var tabBarItem: UITabBarItem {
            switch self {
            case .feed: return UITabBarItem(title: L10n.TabBarItem.feed,
                                            image: Asset.TabBar.feedNotSelected.image,
                                            tag: rawValue).with {
                                                $0.selectedImage = Asset.TabBar.feedSelected.image
                }
            case .favorites: return UITabBarItem(title: L10n.TabBarItem.favorites,
                                            image: Asset.TabBar.favoritesNotSelected.image,
                                            tag: rawValue).with {
                                                $0.selectedImage = Asset.TabBar.favoritesSelected.image
                }
            case .cart: return UITabBarItem(title: L10n.TabBarItem.cart,
                                            image: Asset.TabBar.cartNotSelected.image,
                                            tag: rawValue).with {
                                                $0.selectedImage = Asset.TabBar.cartSelected.image
                }
                
            case .profile: return UITabBarItem(title: L10n.TabBarItem.profile,
                                               image: Asset.TabBar.userNotSelected.image,
                                               tag: rawValue).with {
                                                $0.selectedImage = Asset.TabBar.userSelected.image
                }
            }
        }
    }
    
    func show(tab: Tab) {
        selectedIndex = tab.rawValue
    }
    
    func popSelectedToRoot(animated: Bool = true) {
        guard let nc = (selectedViewController as? UINavigationController) else { return }

        if nc.visibleViewController != nc.viewControllers.first {
            nc.popToRootViewController(animated: animated)
        }
    }
}

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    private func setupStyle() {
        
        tabBar.backgroundImage = .fromColor(.clear)
//        tabBar.shadowImage = nil
        tabBar.tintColor = .tbxBlackTint
        tabBar.unselectedItemTintColor = .tbxBlackTint
        tabBar.backgroundColor = .white
    }
}
