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
        let view = LoadingView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.alpha = 0
        return view
    }()
    
    private lazy var mapView: MKMapView = {
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
        setupView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        loadingAnimation.frame = view.bounds
    }
    
    private func updateLoadingView(show: Bool) {
        if show {
            view.addSubview(loadingAnimation)
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingAnimation.alpha = 1
            }) { _ in
                self.loadingAnimation.startAnimation()
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingAnimation.alpha = 0
            }) { _ in
                self.loadingAnimation.stopAnimation()
                self.loadingAnimation.removeFromSuperview()
            }
        }
    }
    
    private func setupMapPoints(_ points: [MapPointModel]) {
        mapView.addAnnotations(points)
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(mapView)
        mapView.delegate = self
    }
    
    // MARK: - Binding
    
    func bind(_ viewModel: MapViewModel) {
        self.viewModel = viewModel
        
        rx.viewWillAppear
            .map { _ in MapViewModel.Action.viewDidLoad }
            .bind(to: viewModel.action)
            .disposed(by: self.disposeBag)
        
        viewModel.state
            .debug()
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
