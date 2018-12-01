//
//  LocationModel.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct LocationModel: Codable {
    let properties: LocationProperties
    let geometry: LocatioGeometry
}

struct LocatioGeometry: Codable {
    let type: LocatioGeometryType
    let coordinates: [Double]
}

struct LocationProperties: Codable {
    let name: String
    let desc: String?
}
