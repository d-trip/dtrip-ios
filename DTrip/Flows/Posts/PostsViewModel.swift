import Foundation
import RxSwift
import RxCocoa
import DifferenceKit

final class PostsViewModel: ViewModel {
    
    // MARK: - PostsViewModel
    
    var action: AnyObserver<Action> {
        return actionSubject.asObserver()
    }
    var state: Observable<State> {
        return stateSubject
            .catchError { _ in .empty() }
            .observeOn(MainScheduler.instance)
    }
    var navigation: Observable<Navigation> {
        return navigationSubject
            .catchError { _ in .empty() }
            .observeOn(MainScheduler.instance)
    }
    
    // MARK: - Public types
    
    enum Action {
        case viewDidLoad
        case scrollToBottom
        case selectModel(Int)
        case close
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLoadingNextPage(Bool)
        case addItems([PostModel])
        case openPost(PostModel)
        case close
    }
    
    enum Navigation {
        case openPost(PostModel)
        case dismiss(animated: Bool)
    }
    
    struct State {
        var isLoading = true
        var isLoadingNextPage = false
        var postItems: [PostModel] = []
        let postIdentifiers: [PostIdentifier]
        
        init(postIdentifiers: [PostIdentifier]) {
            self.postIdentifiers = postIdentifiers
        }
    }
    
    // MARK: - Private
    
    private let actionSubject = PublishSubject<Action>()
    private let stateSubject = ReplaySubject<State>.create(bufferSize: 1)
    private let navigationSubject = ReplaySubject<Navigation>.create(bufferSize: 1)
    private let initialState: State
    
    private let disposeBag = DisposeBag()
    private let manager: PostManager
    
    init(manager: PostManager, postIdentifiers: [PostIdentifier]) {
        self.manager = manager
        self.initialState = State(postIdentifiers: postIdentifiers)
        setBindings()
    }
    
    private func setBindings() {
        let currentState = stateSubject
            .startWith(initialState)
        
        let mutation = actionSubject
            .flatMap { [weak self] action -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                return self.mutate(action: action)
            }
            .share()
        
        mutation
            .flatMap { [weak self] mutation -> Observable<Navigation> in
                guard let self = self else { return .empty() }
                return self.navigate(mutation: mutation)
            }
            .bind(to: navigationSubject.asObserver())
            .disposed(by: disposeBag)
        
        mutation
            .withLatestFrom(currentState) { ($1, $0) }
            .flatMap { [weak self] (state, mutation) -> Observable<State> in
                guard let self = self else { return .empty() }
                return self.reduce(state: state, mutation: mutation)
            }
            .bind(to: stateSubject.asObserver())
            .disposed(by: disposeBag)
    }
    
    private func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let postItems = stateSubject.take(1)
                .map { state -> [PostIdentifier] in
                    let upperBound = min(Constants.limitPostsRequest, state.postIdentifiers.endIndex)
                    return Array(state.postIdentifiers[0..<upperBound])
                }.flatMap { [weak self] postIdentifiers -> Observable<[PostModel]> in
                    guard postIdentifiers.isEmpty == false, let manager = self?.manager else {
                        return .empty()
                    }
                    return manager.getPosts(identifiers: postIdentifiers)
            }
            
            return .concat([
                .just(.setLoading(true)),
                postItems.map { Mutation.addItems($0) },
                .just(.setLoading(false))
                ])
        case .scrollToBottom:
            let postItems = stateSubject.take(1)
                .map { state -> [PostIdentifier] in
                    let lowerBound = state.postItems.count
                    let upperBound = min(Constants.limitPostsRequest + lowerBound,
                                         state.postIdentifiers.endIndex)
                    guard upperBound > lowerBound else {
                        return []
                    }
                    return Array(state.postIdentifiers[lowerBound..<upperBound])
                }.flatMap { [weak self] postIdentifiers -> Observable<[PostModel]> in
                    guard postIdentifiers.isEmpty == false, let manager = self?.manager else {
                        return .empty()
                    }
                    return manager.getPosts(identifiers: postIdentifiers)
            }
            return .concat([
                .just(.setLoadingNextPage(true)),
                postItems.map { Mutation.addItems($0) },
                .just(.setLoadingNextPage(false)),
                ])
        case .selectModel(let index):
            return stateSubject.take(1)
                .map { state -> PostModel? in
                    guard state.postItems.indices.contains(index) else { return nil }
                    return state.postItems[index]
                }
                .unwrap()
                .map { Mutation.openPost($0) }
        case .close:
            return .just(.close)
        }
    }
    
    private func navigate(mutation: Mutation) -> Observable<Navigation> {
        switch mutation {
        case .close:
            return .just(.dismiss(animated: false))
        case .openPost(let post):
            return .just(.openPost(post))
        default:
            return .empty()
        }
    }
    
    private func reduce(state: State, mutation: Mutation) -> Observable<State> {
        var state = state
        switch mutation {
        case .setLoading(let loading):
            state.isLoading = loading
            return .just(state)
        case .addItems(let items):
            state.postItems += items
            return .just(state)
        default:
            return .empty()
        }
    }
}

private extension PostsViewModel {
    enum Constants {
        static let limitPostsRequest = 30
    }
}
