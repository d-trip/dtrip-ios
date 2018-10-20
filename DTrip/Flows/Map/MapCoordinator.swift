//
//  MapCoordinator.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

final class MapCoordinator: Coordinator {
    
    private let router: Router
    private let view: MapViewController
    
    init(router: Router, view: MapViewController) {
        self.view = view
        self.router = router
        
        //        let viewModel = view.viewModel!
        //
        //        viewModel.showNexPage
        //            .bind(onNext: onNext)
        //            .disposed(by: viewModel.disposeBag)
    }
    
    func start() {
        //        router.setRootModule(view, hideBar: true, animated: true)
        //        router.push(view, animated: true)
        //        router.present(view)
    }
    
    //    func onNext() {
    //
    //    }
}
