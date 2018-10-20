//
//  MainAssembly.swift
//  MusicApp
//
//  Created by Artem Semavin on 11/09/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip

func configureMain(_ container: DependencyContainer) {
    
    unowned let container = container
    
    container.register() {
        MainViewModelImpl() as MainViewModel
    }
    
    container.register {
        MainCoordinator(router: $0, view: $1)
    }
    
    container.register { (model: MainViewModel) -> MainViewController in
        let controller = MainViewController()
        controller.viewModel = model
        return controller
    }
    
}
