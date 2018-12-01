//
//  FeedCoordinator.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

final class FeedCoordinator: Coordinator {
    
    private let router: Router
    private let disposeBag = DisposeBag()
    
    init(router: Router, view: FeedViewController) {
        self.router = router
        
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel must be setted")
            return
        }
        
        viewModel.navigation
            .bind(onNext: navigate)
            .disposed(by: disposeBag)
    }
    
    func start() { }
    
    private func navigate(_ navigation: FeedViewModel.Navigation) {
        switch navigation {
        case .openPost(let post):
            showPostScreen(post)
        }
    }
    
    private func dismissModule(_ animated: Bool) {
        router.dismissModule(animated: animated, completion: nil)
    }
    
    private func showPostScreen(_ postIdentifier: PostIdentifier) {
        let postCoordinator: PostCoordinator = try! container.resolve()
        postCoordinator.start(postIdentifier)
    }
}
