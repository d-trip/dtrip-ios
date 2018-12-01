//
//  FeedViewModel.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

final class FeedViewModel: ViewModel {
    
    // MARK: - FeedViewModel
    
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
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setNextPageLoading(Bool)
        case addItems([PostModel])
        case setItems([PostModel])
        case openPost(PostModel)
    }
    
    enum Navigation {
        case openPost(PostIdentifier)
    }
    
    struct State {
        var isLoading = true
        var isNextPageLoading = false
        var postItems: [PostModel] = []
    }
    
    private var page: Int = 0
    private var totalItems: Int = 0
    private var currentState: State
    
    // MARK: - Private
    
    private let actionSubject = PublishSubject<Action>()
    private let stateSubject = ReplaySubject<State>.create(bufferSize: 1)
    private let navigationSubject = ReplaySubject<Navigation>.create(bufferSize: 1)
    
    private let disposeBag = DisposeBag()
    private let manager: PostManager
    
    init(manager: PostManager) {
        self.manager = manager
        self.currentState = State()
        
        setBindings()
    }
    
    private func setBindings() {
        let currentStateSubject = stateSubject
            .startWith(currentState)
        
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
            .withLatestFrom(currentStateSubject) { ($1, $0) }
            .flatMap { [weak self] (state, mutation) -> Observable<State> in
                guard let self = self else { return .empty() }
                return self.reduce(state: state, mutation: mutation)
            }
            .do(onNext: { [weak self] state in
                self?.currentState = state
            })
            .bind(to: stateSubject.asObserver())
            .disposed(by: disposeBag)
    }
    
    private func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            page = 0
            let setPostItems = fetchPosts(page: page).map {
                Mutation.setItems($0)
            }
            return Observable.concat([
                .just(.setLoading(true)),
                setPostItems,
                .just(.setLoading(false)),
                ])
        case .scrollToBottom:
            guard totalItems > currentState.postItems.count else { return .empty() }
            
            page += 1
            let addPostItems = fetchPosts(page: page).map {
                Mutation.addItems($0)
            }
            return .concat([
                .just(.setNextPageLoading(true)),
                addPostItems,
                .just(.setNextPageLoading(false)),
                ])
        case .selectModel(let index):
            return stateSubject.take(1)
                .map { state -> PostModel? in
                    guard state.postItems.indices.contains(index) else { return nil }
                    return state.postItems[index]
                }
                .unwrap()
                .map { .openPost($0) }
        }
    }
    
    private func navigate(mutation: Mutation) -> Observable<Navigation> {
        switch mutation {
        case .openPost(let post):
            let postIdentifier = PostIdentifier(post.author.name, post.permlink)
            return .just(.openPost(postIdentifier))
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
        case .setNextPageLoading(let loading):
            state.isNextPageLoading = loading
            return .just(state)
        case .setItems(let items):
            state.postItems = items
            return .just(state)
        case .addItems(let items):
            state.postItems += items
            return .just(state)
        default:
            return .empty()
        }
    }
    
    func fetchPosts(page: Int) -> Observable<[PostModel]> {
        return manager.getContent(page: page, limit: Constants.limitPostsRequest).take(1)
            .do(onNext: { [weak self] searchContentModel in
                guard let self = self else { return }
                self.page = searchContentModel.meta.page
                self.totalItems = searchContentModel.meta.total
            }).map {
                $0.items.map { PostIdentifier($0.author, $0.permlink) }
            }.flatMap { [weak self] postIdentifiers -> Observable<[PostModel]> in
                guard postIdentifiers.isEmpty == false, let manager = self?.manager else {
                    return .empty()
                }
                return manager.getPosts(identifiers: postIdentifiers)
            }
    }
}

// MARK: - Constants

private extension FeedViewModel {
    enum Constants {
        static let limitPostsRequest = 30
    }
}
