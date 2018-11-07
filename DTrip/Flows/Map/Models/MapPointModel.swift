//
//  MapPointModel.swift
//  DTrip
//
//  Created by Artem Semavin on 06/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

final class MapPointModel: NSObject, MKAnnotation {
    let name: String
    let permlink: String
    let author: String
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return name
    }
    var subtitle: String? {
        return author
    }
    
    init(name: String, permlink: String, author: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.permlink = permlink
        self.author = author
        self.coordinate = coordinate
    }
}
