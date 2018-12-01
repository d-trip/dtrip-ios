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
        let imageSize = CGSize(width: 0.3, height: 0.3)
        let shadowImage = UIImage.makeColoredImage(.lightGray, size: imageSize)
        
        tabBar.isTranslucent = false
        tabBar.shadowImage = shadowImage
        tabBar.backgroundImage = UIImage()
    }
    
    private func setupControllerIcon() {
        viewControllers?.forEach { controller in
            switch controller {
            case is MapViewController:
                let image = UIImage.TabBar.map
                let selectedImage = UIImage.TabBar.mapSelected
                controller.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
                controller.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            case is FeedViewController:
                let image = UIImage.TabBar.feed
                let selectedImage = UIImage.TabBar.feedSelected
                controller.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
                controller.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            default: break
            }
        }
    }
}
