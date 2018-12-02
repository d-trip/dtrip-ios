import Foundation
import RxSwift

final class PostCoordinator: Coordinator {
    typealias PostModule = (viewModel: PostViewModel, viewController: PostViewController)
    
    private let router: Router
    private let disposeBag = DisposeBag()
    
    init(router: Router) {
        self.router = router
    }

    func start() {
        assertionFailure("Method is not implemented")
    }

    func start(_ postIdentifier: PostIdentifier) {
        let postsModule: PostModule = try! container.resolve(arguments: postIdentifier)
        
        postsModule.viewModel
            .navigation
            .bind(onNext: navigate)
            .disposed(by: disposeBag)

        let navigationController = UINavigationController(rootViewController: postsModule.viewController)
        navigationController.isNavigationBarHidden = true
        router.present(navigationController, animated: true)
    }
    
    private func navigate(_ navigation: PostViewModel.Navigation) {
        switch navigation {
        case .dismiss(let animated):
            dismissModule(animated)
        case let .openShareModule(postModel, animated):
            openShareModule(postModel: postModel, animated: animated)
        }
    }
    
    private func dismissModule(_ animated: Bool) {
        router.dismissModule(animated: animated, completion: nil)
    }

    private func openShareModule(postModel: PostModel, animated: Bool) {
        // Uncomment when share url will be correct
        // let activityItems = [
        //     postModel.title,
        //     postModel.url,
        // ]
        // let activityViewController = UIActivityViewController(activityItems: activityItems,
        //                                                      applicationActivities: nil)

        // router.present(activityViewController, animated: true)
    }
}
