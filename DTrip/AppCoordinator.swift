//
//  AppCoordinator.swift
//  MusicApp
//
//  Created by Artem Semavin on 13/11/2017.
//  Copyright © 2017 CODE PHOBOS UAB. All rights reserved.
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
