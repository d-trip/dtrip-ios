//
//  AppCoordinator.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

enum LaunchInstructor {
	case main
}

final class AppCoordinator: Coordinator {
	
    private let router: Router
    private let main: MainCoordinator
    
    init(router: Router, main: MainCoordinator) {
        self.main = main
        self.router = router
	}
	
	func start() {
        self.start(.main)
	}
	
    func start(_ screen: LaunchInstructor) {
        switch screen {
        case .main:
            main.start()
        }
    }
}
