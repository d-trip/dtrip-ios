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

    private lazy var loadingAnimation: LoadingView = {
        return LoadingView()        
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
        mapView.isRotateEnabled = false
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        
        mapView.userTrackingMode = .none
        
        mapView.register(MapMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MapClusterMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return mapView
    }()

    // MARK: - Managing the View

    override func loadView() {
        super.loadView()
        setupView()
    }

    private func updateLoadingView(show: Bool) {
        if show {
            loadingAnimation.startAnimation(for: view)
        } else {
            loadingAnimation.stopAnimation()
        }
    }
    
    private func setupMapPoints(_ points: Set<MapPointModel>) {
        guard let mapAnnotationsSet = mapView
            .annotations(in: mapView.visibleMapRect) as? Set<MKAnnotationView> else { return }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let mapPoints = mapAnnotationsSet.map { view -> [MapPointModel] in
                if let annotation = view.annotation as? MKClusterAnnotation,
                    let points = annotation.memberAnnotations as? [MapPointModel] {
                    return points
                } else if let point = view.annotation as? MapPointModel {
                    return [point]
                }
                return []
                }.flatMap { $0 }
            
            let newPointsSet = Set(points)
            let annotationsSet = newPointsSet.subtracting(mapPoints)
            
            if !annotationsSet.isEmpty {
                let annotationArray = Array(annotationsSet)

                DispatchQueue.main.async {
                    self?.mapView.addAnnotations(annotationArray)
                }
            }
        }
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Binding
    
    func bind(_ viewModel: MapViewModel) {
        self.viewModel = viewModel
        
        rx.viewDidLoad
            .map { _ in MapViewModel.Action.viewDidLoad }
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
            .delay(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.updateLoadingView(show: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let topRightPoint = CGPoint(x: mapView.frame.maxX, y: mapView.frame.minY)
        let topRight = mapView.convert(topRightPoint, toCoordinateFrom: mapView)
        
        let bottomLeftPoint = CGPoint(x: mapView.frame.minX, y: mapView.frame.maxY)
        let bottomLeft = mapView.convert(bottomLeftPoint, toCoordinateFrom: mapView)
        
        viewModel.action.onNext(.didChangeVisibleRegion(bottomLeft: bottomLeft, topRight: topRight))
    }
    
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
