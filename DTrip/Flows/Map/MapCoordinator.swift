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
        
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel must be setted")
            return
        }
        
        viewModel.showMapPointsContent
            .filter { $0.count == 1 }
            .map { $0.first }
            .unwrap()
            .bind(onNext: showPostScreen)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.showMapPointsContent
            .filter { $0.count > 1 }
            .bind(onNext: showPostFeed)
            .disposed(by: viewModel.disposeBag)
    }
    
    func start() {
        //        router.setRootModule(view, hideBar: true, animated: true)
        //        router.push(view, animated: true)
        //        router.present(view)
    }
    
    func showPostScreen(post: (author: String, permlink: String)) {
        
    }
    
    func showPostFeed(posts: [(author: String, permlink: String)]) {
        
    }
}
