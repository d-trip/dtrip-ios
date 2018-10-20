//
//  ServicesAssembly.swift
//  MusicApp
//
//  Created by Artem Semavin on 11/09/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip

func configureServices(_ container: DependencyContainer) {
    
    unowned let container = container

    container.register(.singleton) { _ -> Router in
        let rootController =  UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
        return RouterImp(rootController: rootController) as Router
    }
}
