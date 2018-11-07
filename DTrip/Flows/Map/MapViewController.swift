//
//  MapViewController.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

final class MapViewController: UIViewController {
    
    //MARK: - Outlets
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(MapMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MapClusterMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }()
    
    //MARK: - Property
    
    var viewModel: MapViewModel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        centreMap(on: initialLocation)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }

    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(mapView)
    }

    private func setupRx() {
        viewModel.postCoordinates
            .drive(onNext: { [weak self] points in
                self?.setupMapPoints(points)
            })
            .disposed(by: viewModel.disposeBag)
    }

    private func setupMapPoints(_ points: [MapPointModel]) {
        mapView.addAnnotations(points)
    }
    
    private func centreMap(on location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
//                                                  latitudinalMeters: regionRadius * 2.0,
//                                                  longitudinalMeters: regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
    }
}
