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
    
    init(router: Router, view: MainViewController) {
        self.view = view
        self.router = router
        
        //        let viewModel = view.viewModel!
        //
        //        viewModel.showNextPage
        //            .bind(onNext: onNext)
        //            .disposed(by: viewModel.disposeBag)
    }
    
    func start() {
        router.setRootModule(view, hideBar: true, animated: false)
    }
    
    //    func onNext() {
    //
    //    }
}
