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

    //MARK: - Private properties
    
    private(set) var viewModel: MapViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - UI properties

    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(MapMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MapClusterMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }()

    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    private func updateLoadingView(show: Bool) {
        // ToDo: - Add loading view
    }
    
    private func setupMapPoints(_ points: [MapPointModel]) {
        mapView.addAnnotations(points)
    }

    // MARK: - Private methods

    private func setupUI() {
        view.addSubview(mapView)
        mapView.delegate = self
    }

    // MARK: - Binding
    
    func bind(_ viewModel: MapViewModel) {
        self.viewModel = viewModel
        
        rx.viewDidLoad
            .map { MapViewModel.Action.viewDidLoad }
            .bind(to: viewModel.action)
            .disposed(by: self.disposeBag)
        
        viewModel.state
            .map { $0.points }
            .subscribe(onNext: { [weak self] points in
                self?.setupMapPoints(points)
            })
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                self?.updateLoadingView(show: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKClusterAnnotation,
           let annotations = annotation.memberAnnotations as? [MapPointModel] {
            viewModel.action.onNext(.selectIdentifiers(annotations))
        } else if let annotation = view.annotation as? MapPointModel {
            viewModel.action.onNext(.selectIdentifier(annotation))
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}
