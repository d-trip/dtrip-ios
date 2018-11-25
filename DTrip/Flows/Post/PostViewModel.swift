import Foundation
import RxSwift
import RxCocoa

protocol PostViewModel {
    var post: Observable<PostModel> { get }
    var setPostIdentifier: AnyObserver<PostIdentifier> { get }
    var setPostModel: AnyObserver<PostModel> { get }
    var disposeBag: DisposeBag { get }
}

final class PostViewModelImp: PostViewModel {

    // MARK: - PostViewModel

    let disposeBag = DisposeBag()

    var post: Observable<PostModel> {
        return postModelSubject
            .catchError { _ in .empty() }
            .observeOn(MainScheduler.instance)
    }

    var setPostIdentifier: AnyObserver<PostIdentifier> {
        return postIdentifierSubject.asObserver()
    }

    var setPostModel: AnyObserver<PostModel> {
        return postModelSubject.asObserver()
    }

    // MARK: - Private

    private let postIdentifierSubject = ReplaySubject<PostIdentifier>.create(bufferSize: 1)
    private let postModelSubject = ReplaySubject<PostModel>.create(bufferSize: 1)

    // MARK: - Init

    private let manager: PostManager

    init(manager: PostManager) {
        self.manager = manager

        postIdentifierSubject
            .flatMap(manager.getPost)
            .bind(to: postModelSubject.asObserver())
            .disposed(by: disposeBag)

    }
}
