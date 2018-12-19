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
    
    let scheduler = SerialDispatchQueueScheduler(queue: DispatchQueue.global(qos: .userInitiated),
                                                 internalSerialQueueName: "com.ooodin.dtrip.mapViewModel")
    
    // MARK: - Public types
    
    enum Action {
        case viewDidLoad
        case didChangeVisibleRegion(bottomLeft: CLLocationCoordinate2D, topRight: CLLocationCoordinate2D)
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
        var isLoading = false
        var points: Set<MapPointModel> = Set()
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
            .debounce(0.5, scheduler: MainScheduler.asyncInstance)
            .observeOn(scheduler)
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
            return .empty()
        case let .didChangeVisibleRegion(bottomLeft: bottomLeft, topRight: topRight):
            let points = manager.getContent(page: 0,
                                            limit: Constants.limitPostsRequest,
                                            bottomLeft: bottomLeft,
                                            topRight: topRight)
                .take(1)
                .map { [weak self] content -> [MapPointModel] in
                    guard let self = self else { return [] }
                    return self.performContentCoordinates(content.items)
                }

            return points.map { .addItems($0) }
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
            state.points.formUnion(points)
            return .just(state)
        default:
            return .empty()
        }
    }
    
    private func performContentCoordinates(_ content: [SearchContenItemModel]) -> [MapPointModel] {
        return content
            .map(makeMapPointModel)
            .compactMap { $0 }
    }

    private func makeMapPointModel(_ content: SearchContenItemModel) -> MapPointModel? {
        let coordinatesArray = content.location.geometry.coordinates
        let latitudeIndex = 1
        let longitudeIndex = 0

        guard coordinatesArray.indices.contains(latitudeIndex),
            coordinatesArray.indices.contains(longitudeIndex) else { return nil }

        let latitude = coordinatesArray[latitudeIndex]
        let longitude = coordinatesArray[longitudeIndex]
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        return MapPointModel(name: content.location.properties.name,
                             permlink: content.permlink,
                             author: content.author,
                             coordinate: coordinate)
    }
}

// MARK: - Constants

private extension MapViewModel {
    enum Constants {
        static let limitPostsRequest = 1000
    }
}
