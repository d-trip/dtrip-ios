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
        FeedViewModel(manager: $0)
    }
    
    container.register {
        FeedCoordinator(router: $0, view: $1)
    }
    
    container.register { (model: FeedViewModel) -> FeedViewController in
        let controller = FeedViewController()
        controller.bind(model)
        return controller
    }
}
