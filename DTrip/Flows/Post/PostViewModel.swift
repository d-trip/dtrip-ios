import Foundation
import RxSwift
import RxCocoa

protocol PostViewModel {
//    var post: Driver<PostItem> { get }
    var setPostIdentifier: AnyObserver<PostIdentifier> { get }
    var setPostModel: AnyObserver<PostModel> { get }
    var disposeBag: DisposeBag { get }
}

final class PostViewModelImp: PostViewModel {

    // MARK: - PostViewModel

    let disposeBag = DisposeBag()

//    var post: Driver<PostItem> {
//        let error: PostItem = .errorItem(title: "Error")
//        return postSubject.asDriver(onErrorJustReturn: error)
//    }

    var setPostIdentifier: AnyObserver<PostIdentifier> {
        return postIdentifierSubject.asObserver()
    }

    var setPostModel: AnyObserver<PostModel> {
        return postModelSubject.asObserver()
    }

    // MARK: - Private

//    private let postSubject = ReplaySubject<PostItem>.create(bufferSize: 1)
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

//        postIdentifierSubject
//            .map { _ in PostItem.loadingItem(title: "Loading...", animate: true) }
//            .bind(to: postSubject.asObserver())
//            .disposed(by: disposeBag)
//
//        postModelSubject
//            .map { PostItem.postItem(post: $0) }
//            .bind(to: postSubject.asObserver())
//            .disposed(by: disposeBag)
    }
}
