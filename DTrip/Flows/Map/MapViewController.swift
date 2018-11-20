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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }

    // MARK: - Private methods

    private func setupUI() {
        view.addSubview(mapView)
        mapView.delegate = self
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
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKClusterAnnotation,
           let annotations = annotation.memberAnnotations as? [MapPointModel] {
            viewModel.didSelectMapPoint.onNext(annotations)
        } else if let annotation = view.annotation as? MapPointModel {
            viewModel.didSelectMapPoint.onNext([annotation])
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}
