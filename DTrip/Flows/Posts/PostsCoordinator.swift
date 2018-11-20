import Foundation
import RxSwift
import RxCocoa

final class PostsCoordinator: Coordinator {

    private let router: Router
    private let view: PostsViewController
    private let postCoordinator: PostCoordinator

    init(router: Router,
         view: PostsViewController,
         postCoordinator: PostCoordinator) {
        self.view = view
        self.router = router
        self.postCoordinator = postCoordinator

        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel must be setted")
            return
        }

        viewModel.showPostContent
            .bind(onNext: showPostScreen)
            .disposed(by: viewModel.disposeBag)
    }

    func start() {
        assertionFailure("Method is not implemented")
    }

    func start(_ postIdentifiers: [PostIdentifier]) {
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel is not found")
            return
        }

        viewModel.setPostIdentifiers.onNext(postIdentifiers)

        let navigationController = UINavigationController(rootViewController: view)
        navigationController.isNavigationBarHidden = true
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.definesPresentationContext = false
        navigationController.providesPresentationContextTransitionStyle = false
        router.present(navigationController, animated: false)
    }

    private func showPostScreen(_ postModel: PostModel) {
        postCoordinator.start(postModel)
    }
}
