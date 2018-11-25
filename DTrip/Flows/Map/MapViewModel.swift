//
//  MapViewModel.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class MapViewModel: ViewModel {
    
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
        case selectIdentifier(MapPointModel)
        case selectIdentifiers([MapPointModel])
    }
    
    enum Mutation {
        case setLoading(Bool)
        case addItems([MapPointModel])
        case openPost(PostIdentifier)
        case openPostList([PostIdentifier])
    }
    
    enum Navigation {
        case openPost(PostIdentifier)
        case openPostList([PostIdentifier])
    }
    
    struct State {
        var isLoading = true
        var points: [MapPointModel] = []
    }
    
    // MARK: - Private
    
    private let actionSubject = PublishSubject<Action>()
    private let stateSubject = ReplaySubject<State>.create(bufferSize: 1)
    private let navigationSubject = ReplaySubject<Navigation>.create(bufferSize: 1)
    private let initialState: State

    private let disposeBag = DisposeBag()
    private let manager: PostManager
    
    init(manager: PostManager) {
        self.manager = manager
        self.initialState = State()
        
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
            let points = manager.content
                .map { [weak self] content -> [MapPointModel] in
                    guard let self = self else { return [] }
                    return self.performContentCoordinates(content)
                }

            return .concat([
                .just(.setLoading(true)),
                points.map { .addItems($0) },
                .just(.setLoading(false))
            ])
        case .selectIdentifier(let mapPoint):
            let identifier = PostIdentifier(mapPoint.author, mapPoint.permlink)
            return .just(.openPost(identifier))
        case .selectIdentifiers(let mapPoints):
            let identifiers = mapPoints.map { PostIdentifier($0.author, $0.permlink) }
            return .just(.openPostList(identifiers))
        }
    }
    
    private func navigate(mutation: Mutation) -> Observable<Navigation> {
        switch mutation {
        case .openPost(let identifier):
            return .just(.openPost(identifier))
        case .openPostList(let identifiers):
            return .just(.openPostList(identifiers))
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
        case .addItems(let points):
            state.points += points
            return .just(state)
        default:
            return .empty()
        }
    }
    
    private func performContentCoordinates(_ content: [SearchContenResultModel]) -> [MapPointModel] {
        return content
            .map(makeMapPointModel)
            .compactMap { $0 }
    }

    private func makeMapPointModel(_ content: SearchContenResultModel) -> MapPointModel? {
        guard content.type == .post,
            content.meta.location.geometry.type == .point else { return nil }

        let coordinatesArray = content.meta.location.geometry.coordinates
        let latitudeIndex = 1
        let longitudeIndex = 0

        guard coordinatesArray.indices.contains(latitudeIndex),
            coordinatesArray.indices.contains(longitudeIndex) else { return nil }

        let latitude = coordinatesArray[latitudeIndex]
        let longitude = coordinatesArray[longitudeIndex]
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        return MapPointModel(name: content.meta.location.properties.name,
                             permlink: content.permlink,
                             author: content.author,
                             coordinate: coordinate)
    }
}
