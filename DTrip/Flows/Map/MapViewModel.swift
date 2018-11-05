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
    var postCoordinates: Driver<([CLLocationCoordinate2D])> { get }

    var disposeBag: DisposeBag { get }
}

final class MapViewModelImp: MapViewModel {
    var postCoordinates: Driver<([CLLocationCoordinate2D])> {
        return postCoordinatesSubject.asDriver(onErrorJustReturn: [])
    }

    let postCoordinatesSubject = ReplaySubject<[CLLocationCoordinate2D]>.create(bufferSize: 1)

    let disposeBag = DisposeBag()
    let manager: PostManager
    
    init(manager: PostManager) {
        self.manager = manager
        
    }
}
