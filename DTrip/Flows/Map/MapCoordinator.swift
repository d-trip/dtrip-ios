//
//  MapCoordinator.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

final class MapCoordinator: Coordinator {
    
    private let router: Router
    private let view: MapViewController
    private let posts: PostsCoordinator
    private let post: PostCoordinator
    
    init(router: Router,
         view: MapViewController,
         posts: PostsCoordinator,
         post: PostCoordinator) {
        self.view = view
        self.router = router
        self.posts = posts
        self.post = post
        
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel must be setted")
            return
        }
        viewModel.showPostsContent
            .observeOn(MainScheduler.asyncInstance)
            .filter { $0.count == 1 }
            .map { $0.first }
            .unwrap()
            .bind(onNext: showPostScreen)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.showPostsContent
            .observeOn(MainScheduler.asyncInstance)
            .filter { $0.count > 1 }
            .bind(onNext: showPostFeed)
            .disposed(by: viewModel.disposeBag)
    }
    
    func start() {}
    
    private func showPostScreen(postIdentifier: PostIdentifier) {
        post.start(postIdentifier)
    }
    
    private func showPostFeed(postIdentifiers: [PostIdentifier]) {
        posts.start(postIdentifiers)
    }
}
