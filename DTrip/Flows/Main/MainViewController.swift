//
//  MainViewController.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

final class MainViewController: UITabBarController {
    
    //MARK: - Property
    
    var viewModel: MainViewModel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Public methods
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        setupControllerIcon()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        tabBar.isTranslucent = false
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
    
    private func setupControllerIcon() {
        viewControllers?.forEach { controller in
            switch controller {
            case is MapViewController:
                let image = UIImage(named: "map")
                let selectedImage = UIImage(named: "map_selected")
                controller.tabBarItem = UITabBarItem.init(title: nil, image: image, selectedImage: selectedImage)
            case is FeedViewController:
                let image = UIImage(named: "feed")
                let selectedImage = UIImage(named: "feed_selected")
                controller.tabBarItem = UITabBarItem.init(title: nil, image: image, selectedImage: selectedImage)
            default: break
            }
        }
    }
}
