//
//  MainAssembly.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip

func configureMain(_ container: DependencyContainer) {
    unowned let container = container
    
    container.register() {
        MainViewModelImpl() as MainViewModel
    }
    
    container.register {
        MainCoordinator(router: $0, view: $1, map: $2, feed: $3)
    }
    
    container.register { (
        model: MainViewModel,
        mapController: MapViewController,
        feedController: FeedViewController) -> MainViewController in
        
        let controller = MainViewController()
        controller.viewModel = model
        controller.setViewControllers([mapController, feedController], animated: false)
        controller.selectedIndex = 0
        
        return controller
    }
}
