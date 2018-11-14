import Foundation

final class PostsCoordinator: Coordinator {

    private let router: Router
    private let view: PostsViewController

    init(router: Router, view: PostsViewController) {
        self.view = view
        self.router = router
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
        router.push(view)
    }
}
