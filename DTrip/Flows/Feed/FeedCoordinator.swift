//
//  FeedCoordinator.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

final class FeedCoordinator: Coordinator {
    
    private let router: Router
    private let view: FeedViewController
    
    init(router: Router, view: FeedViewController) {
        self.view = view
        self.router = router
        
        //        let viewModel = view.viewModel!
        //
        //        viewModel.showNextPage
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
