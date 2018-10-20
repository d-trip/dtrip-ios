//
//  FeedAssembly.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip

func configureFeed(_ container: DependencyContainer) {
    unowned let container = container
    
    container.register() {
        FeedViewModelImp() as FeedViewModel
    }
    
    container.register {
        FeedCoordinator(router: $0, view: $1)
    }
    
    container.register { (model: FeedViewModel) -> FeedViewController in
        let controller = FeedViewController()
        controller.viewModel = model
        return controller
    }
}
