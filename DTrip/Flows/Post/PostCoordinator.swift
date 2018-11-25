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
        
        router.present(postsModule.viewController, animated: true)
    }

    func start(_ postModel: PostModel) {
        let postsModule: PostModule = try! container.resolve(arguments: postModel)
        
        postsModule.viewModel
            .navigation
            .bind(onNext: navigate)
            .disposed(by: disposeBag)
        
        router.present(postsModule.viewController, animated: true)
    }
    
    private func navigate(_ navigation: PostViewModel.Navigation) {
        switch navigation {
        case .dismiss(let animated):
            dismissModule(animated)
        }
    }
    
    private func dismissModule(_ animated: Bool) {
        router.dismissModule(animated: animated, completion: nil)
    }
    
}
