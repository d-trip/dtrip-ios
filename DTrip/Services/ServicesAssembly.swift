//
//  ServicesAssembly.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Dip

func configureServices(_ container: DependencyContainer) {
    unowned let container = container

    container.register(.singleton) { _ -> Router in
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController! as? UINavigationController else {
            fatalError("rootViewController must be UINavigationController")
        }
        return RouterImp(rootController: rootController) as Router
    }
    
    container.register(.singleton) {
        PostManagerImp(network: $0) as PostManager
    }
    
    let network = container.register(.singleton, type: Networking.self) {
        return Networking()
    }
    
    container.register(network, type: PostManagerNetworking.self)
}
