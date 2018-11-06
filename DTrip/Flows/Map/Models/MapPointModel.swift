//
//  MapPointModel.swift
//  DTrip
//
//  Created by Artem Semavin on 06/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import CoreLocation

struct MapPointModel {
    let name: String
    let permlink: String
    let author: String
    let coordinate: CLLocationCoordinate2D
}
