//
//  AppContainer.swift
//  MusicApp
//
//  Created by Artem Semavin on 13/11/2017.
//  Copyright © 2017 CODE PHOBOS UAB. All rights reserved.
//

import Dip
import UIKit

func configureApplicationAssembly(_ container: DependencyContainer) {

	unowned let container = container
	
    container.register { container }
    container.register { UIApplication.shared }
        
    container.register() {
        AppCoordinator(router: try! container.resolve(), main: try! container.resolve())
    }

    //Services
    configureServices(container)

    //Screens
    configureMain(container)
}
