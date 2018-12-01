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
    private let disposeBag = DisposeBag()
    
    init(router: Router,
         view: MapViewController) {
        self.router = router
  
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel must be setted")
            return
        }
        
        viewModel.navigation
            .bind(onNext: navigate)
            .disposed(by: disposeBag)
    }
    
    func start() {}
    
    private func navigate(_ navigation: MapViewModel.Navigation) {
        switch navigation {
        case .openPost(let postIdentifier):
            showPostScreen(postIdentifier: postIdentifier)
        case .openPostList(let postIdentifiers):
            showPostFeed(postIdentifiers: postIdentifiers)
        }
    }
    
    private func showPostScreen(postIdentifier: PostIdentifier) {
        let post: PostCoordinator = try! container.resolve()
        post.start(postIdentifier)
    }
    
    private func showPostFeed(postIdentifiers: [PostIdentifier]) {
        let posts: PostsCoordinator = try! container.resolve()
        posts.start(postIdentifiers)
    }
}
