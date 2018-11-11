import Foundation

final class PostsCoordinator: Coordinator {

    private let router: Router
    private let view: PostsViewController

    init(router: Router, view: PostsViewController) {
        self.view = view
        self.router = router
    }

    func start() {
    }
}