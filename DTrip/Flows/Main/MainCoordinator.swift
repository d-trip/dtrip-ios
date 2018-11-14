//
//  MainCoordinator.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

final class MainCoordinator: Coordinator {
    
    private let router: Router
    private let view: MainViewController
    private let map: MapCoordinator
    
    init(router: Router, view: MainViewController, map: MapCoordinator) {
        self.view = view
        self.router = router
        self.map = map
        
    }
    
    func start() {
        router.setRootModule(view, hideBar: true, animated: false)
    }
}
