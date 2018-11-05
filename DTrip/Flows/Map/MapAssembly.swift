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
    
    container.register() {
        MapViewModelImp(manager: $0) as MapViewModel
    }
    
    container.register {
        MapCoordinator(router: $0, view: $1)
    }
    
    container.register { (model: MapViewModel) -> MapViewController in
        let controller = MapViewController()
        controller.viewModel = model
        return controller
    }
    
}
