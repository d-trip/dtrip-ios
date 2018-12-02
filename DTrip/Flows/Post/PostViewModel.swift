import Foundation
import RxSwift
import RxCocoa

final class PostViewModel: ViewModel {

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
        case close
        case share
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setPost(PostModel)
        case close
        case share(PostModel)
    }
    
    enum Navigation {
        case dismiss(animated: Bool)
        case openShareModule(postModel: PostModel, animated: Bool)
    }
    
    struct State {
        var isLoading = true
        var postModel: PostModel? = nil
        let postIdentifier: PostIdentifier
        
        init(postIdentifier: PostIdentifier) {
            self.postIdentifier = postIdentifier
        }
    }
    
    // MARK: - Private
    
    private let actionSubject = PublishSubject<Action>()
    private let stateSubject = ReplaySubject<State>.create(bufferSize: 1)
    private let navigationSubject = ReplaySubject<Navigation>.create(bufferSize: 1)
    private let initialState: State
    
    private let disposeBag = DisposeBag()
    private let manager: PostManager
    
    init(manager: PostManager, postIdentifier: PostIdentifier) {
        self.manager = manager
        self.initialState = State(postIdentifier: postIdentifier)
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
            let postModel = stateSubject
                .flatMap { [weak self] state -> Observable<PostModel> in
                    guard let manager = self?.manager else { return .never() }
                    return manager.getPost(identifier: state.postIdentifier)
                }.take(1)
            return .concat(
                [
                    .just(.setLoading(true)),
                    postModel.map { Mutation.setPost($0) },
                    .just(.setLoading(false))
                ])
        case .close:
            return .just(.close)
        case .share:
            return stateSubject
                .take(1)
                .map { $0.postModel }
                .unwrap()
                .map { Mutation.share($0) }
        }
    }
    
    private func navigate(mutation: Mutation) -> Observable<Navigation> {
        switch mutation {
        case .close:
            return .just(.dismiss(animated: true))
        case .share(let postModel):
            return .just(.openShareModule(postModel: postModel, animated: true))
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
        case .setPost(let postModel):
            state.postModel = postModel
            return .just(state)
        default:
            return .empty()
        }
    }
}
