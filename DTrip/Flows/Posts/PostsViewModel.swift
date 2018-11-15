import Foundation
import RxSwift
import RxCocoa
import DifferenceKit

typealias PostItemDiffs = StagedChangeset<[PostItem]>

protocol PostsViewModel {
    var posts: Driver<[PostItem]> { get }
    var setPostIdentifiers: AnyObserver<[PostIdentifier]> { get }
 
    var disposeBag: DisposeBag { get }
}

final class PostsViewModelImp: PostsViewModel {
    var setPostIdentifiers: AnyObserver<[PostIdentifier]> {
        return postIdentifiersSubject.asObserver()
    }
    var posts: Driver<[PostItem]> {
        let error: PostItem = .errorItem(title: Messages.error)
        return postsSubject.asDriver(onErrorJustReturn: [error])
    }
    
    let disposeBag = DisposeBag()
    
    private let postsSubject = ReplaySubject<[PostItem]>.create(bufferSize: 1)
    private let postIdentifiersSubject = ReplaySubject<[PostIdentifier]>.create(bufferSize: 1)

    private let manager: PostManager
    
    init(manager: PostManager) {
        self.manager = manager
        
        postIdentifiersSubject
            .map { _ -> [PostItem] in [.loadingItem(title: Messages.loading, animate: true)] }
            .bind(to: postsSubject.asObserver())
            .disposed(by: disposeBag)
        
        postIdentifiersSubject
            .flatMap(manager.getPosts)
            .map { $0.map { PostItem.postItem(post: $0) } }
            .bind(to: postsSubject.asObserver())
            .disposed(by: disposeBag)
    }
}

extension PostsViewModelImp {
    struct Messages {
        static let loading = "Loading..."
        static let error = "Error"
    }
}
