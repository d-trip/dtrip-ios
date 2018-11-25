//
//  MapAssembly.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip

func configureMap(_ container: DependencyContainer) {
    unowned let container = container
    
    container.register() { (postIdentifiers: [PostIdentifier])
        -> (viewModel: MapViewModel, viewController: MapViewController) in
        let viewModel: MapViewModel = try! container.resolve()
        let viewController: MapViewController = try! container.resolve(arguments: viewModel)
        return (viewModel, viewController)
    }
    
    container.register() {
        MapViewModel(manager: $0)
    }
    
    container.register {
        MapCoordinator(router: $0, view: $1)
    }
    
    container.register { (model: MapViewModel) -> MapViewController in
        let controller = MapViewController()
        controller.bind(model)
        return controller
    }
    
}
