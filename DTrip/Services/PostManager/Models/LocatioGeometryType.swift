//
//  LocatioGeometryType.swift
//  DTrip
//
//  Created by Artem Semavin on 06/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

enum LocatioGeometryType: String, Codable {
    case point = "point"
    case other
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
            let typeString = try? container.decode(String.self) {
            self = LocatioGeometryType(typeString)
        } else {
            self = .other
        }
    }
    
    init(_ value: String) {
        switch value.lowercased() {
        case "point":
            self = .point
        default:
            self = .other
        }
    }
}
