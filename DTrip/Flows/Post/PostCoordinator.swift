import Foundation
import RxSwift

final class PostCoordinator: Coordinator {

    private let router: Router
    private let view: PostViewController

    init(router: Router, view: PostViewController) {
        self.router = router
        self.view = view
    }

    func start() {
        assertionFailure("Method is not implemented")
    }

    func start(_ postIdentifier: PostIdentifier) {
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel is not found")
            return
        }

        viewModel.setPostIdentifier.onNext(postIdentifier)
        router.present(view, animated: true)
    }

    func start(_ postModel: PostModel) {
        guard let viewModel = view.viewModel else {
            assertionFailure("ViewModel is not found")
            return
        }

        viewModel.setPostModel.onNext(postModel)
        router.present(view, animated: true)
    }
}
