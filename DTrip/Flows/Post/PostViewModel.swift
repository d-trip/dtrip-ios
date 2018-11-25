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
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setPost(PostModel)
        case close
    }
    
    enum Navigation {
        case dismiss(animated: Bool)
    }
    
    struct State {
        var isLoading = true
        var postModel: PostModel?
        var postIdentifier: PostIdentifier?
        
        init(postIdentifier: PostIdentifier) {
            self.postIdentifier = postIdentifier
            self.postModel = nil
        }
        init(postModel: PostModel) {
            self.postIdentifier = nil
            self.postModel = postModel
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
    
    init(manager: PostManager, postModel: PostModel) {
        self.manager = manager
        self.initialState = State(postModel: postModel)
        setBindings()
    }
    
    private func setBindings() {
        let currentState = stateSubject
            .startWith(initialState)
        
        let mutation = actionSubject
            .debounce(0.5, scheduler: MainScheduler.instance)
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
            let postModel = stateSubject.take(1)
                .flatMap { [weak self] state -> Observable<PostModel> in
                    if let postModel = state.postModel {
                        return .just(postModel)
                    } else if let postIdentifier = state.postIdentifier, let manager = self?.manager {
                        return manager.getPost(identifier: postIdentifier)
                    }
                    return .never()
                }
            return .concat([
                .just(.setLoading(true)),
                postModel.map { Mutation.setPost($0) },
                .just(.setLoading(false))
                ])
        case .close:
            return .just(.close)
        }
    }
    
    private func navigate(mutation: Mutation) -> Observable<Navigation> {
        switch mutation {
        case .close:
            return .just(.dismiss(animated: false))
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
