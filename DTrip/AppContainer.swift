//
//  AppContainer.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip
import UIKit

func configureApplicationAssembly(_ container: DependencyContainer) {

	unowned let container = container
	
    container.register { container }
    container.register { UIApplication.shared }
        
    container.register() { (router: Router, mainCoordinator: MainCoordinator) -> AppCoordinator in
        return AppCoordinator(router: router, main: mainCoordinator)
    }

    //Services
    configureServices(container)

    //Screens
    configureMain(container)
    configureFeed(container)
    configureMap(container)
    configurePosts(container)
    configurePost(container)
}
