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

protocol MapViewModel {
    var postCoordinates: Driver<([MapPointModel])> { get }
    var showMapPointsContent: Observable<[(author: String, permlink: String)]> { get }
    
    var didSelectMapPoint: AnyObserver<[MapPointModel]> { get }
    var disposeBag: DisposeBag { get }
}

final class MapViewModelImp: MapViewModel {
    var showMapPointsContent: Observable<[(author: String, permlink: String)]> {
        return mapPointsSubject.map {
            $0.map { ($0.author, $0.permlink) }
        }
    }
    var didSelectMapPoint: AnyObserver<[MapPointModel]> {
        return mapPointsSubject.asObserver()
    }
    var postCoordinates: Driver<([MapPointModel])> {
        return postCoordinatesSubject.asDriver(onErrorJustReturn: [])
    }
    
    let mapPointsSubject = PublishSubject<[MapPointModel]>()
    let postCoordinatesSubject = ReplaySubject<[MapPointModel]>.create(bufferSize: 1)

    let disposeBag = DisposeBag()
    let manager: PostManager
    
    init(manager: PostManager) {
        self.manager = manager

        manager.content
            .map(performContentCoordinates)
            .bind(to: postCoordinatesSubject.asObserver())
            .disposed(by: disposeBag)
    }

    func performContentCoordinates(_ content: [SearchContenResulttModel]) -> [MapPointModel] {
        return content
            .map(makeMapPointModel)
            .compactMap { $0 }
    }
    
    func makeMapPointModel(_ content: SearchContenResulttModel) -> MapPointModel? {
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
