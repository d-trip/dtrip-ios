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
    private let posts: PostsCoordinator
    
    init(router: Router, view: MapViewController, posts: PostsCoordinator) {
        self.view = view
        self.router = router
        self.posts = posts
        
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel must be setted")
            return
        }
        
        viewModel.showPostsContent
            .filter { $0.count == 1 }
            .map { $0.first }
            .unwrap()
            .bind(onNext: showPostScreen)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.showPostsContent
            .filter { $0.count > 1 }
            .bind(onNext: showPostFeed)
            .disposed(by: viewModel.disposeBag)
    }
    
    func start() {}
    
    func showPostScreen(postIdentifier: PostIdentifier) {
        // ToDo: - Open single post screen
        posts.start([postIdentifier])
    }
    
    func showPostFeed(postIdentifiers: [PostIdentifier]) {
        posts.start(postIdentifiers)
    }
}
