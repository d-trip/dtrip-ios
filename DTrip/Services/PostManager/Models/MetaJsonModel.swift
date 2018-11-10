//
//  MetaModel.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct MetaJsonModel: Codable {
    let tags: [String]
    let location: LocationModel
    let format: String
    let app: String
    let community: String
}
