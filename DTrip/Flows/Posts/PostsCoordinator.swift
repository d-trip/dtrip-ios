import Foundation
import RxSwift
import RxCocoa

final class PostsCoordinator: Coordinator {
    typealias PostsModule = (viewModel: PostsViewModel, viewController: PostsViewController)
    
    private let router: Router
    private let disposeBag: DisposeBag

    init(router: Router) {
        self.router = router
        self.disposeBag = DisposeBag()
    }

    func start() {
        assertionFailure("Method is not implemented")
    }

    func start(_ postIdentifiers: [PostIdentifier]) {
        let postsModule: PostsModule = try! container.resolve(arguments: postIdentifiers)
        
        postsModule.viewModel
            .navigation
            .bind(onNext: navigate)
            .disposed(by: disposeBag)
        
        let navigationController = UINavigationController(rootViewController: postsModule.viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.definesPresentationContext = false
        navigationController.providesPresentationContextTransitionStyle = false
        router.present(navigationController, animated: false)
    }

    private func navigate(_ navigation: PostsViewModel.Navigation) {
        switch navigation {
        case .dismiss(let animated):
            dismissModule(animated)
        case .openPost(let post):
            showPostScreen(post)
        }
    }
    
    private func dismissModule(_ animated: Bool) {
        router.dismissModule(animated: animated, completion: nil)
    }
    
    private func showPostScreen(_ postModel: PostModel) {
//        postCoordinator.start(postModel)
    }
}
