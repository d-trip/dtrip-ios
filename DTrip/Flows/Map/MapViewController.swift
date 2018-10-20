//
//  MapViewController.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit
import Mapbox

final class MapViewController: UIViewController {
    
    //MARK: - Outlets
    
    var mapView: MGLMapView = {
        let mapView = MGLMapView()
        mapView.styleURL = URL(string: Config.map.styleURL)
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return mapView
    }()
    
    //MARK: - Property
    
    var viewModel: MapViewModel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }

    // MARK: - Private methods
    
    func setupUI() {
        view.addSubview(mapView)
    }
}
