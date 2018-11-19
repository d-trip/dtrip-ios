//
//  MapMarkerView.swift
//  DTrip
//
//  Created by Artem Semavin on 07/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import MapKit

final class MapMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            configure(with: annotation)
        }
    }
    
    private func configure(with annotation: MKAnnotation?) {
//        guard annotation is MapPointModel else { return }
        markerTintColor = .blue
        clusteringIdentifier = String(describing: MapMarkerView.self)
        detailCalloutAccessoryView = nil
        canShowCallout = false
    }
}
