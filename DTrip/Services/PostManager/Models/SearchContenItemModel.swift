//
//  ContentModel.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct SearchContenItemModel: Codable {
    let id: String
    let author: String
    let itemCreated: String
    let location: LocationModel
    let permlink: String
    let title: String
    let created: Date
    let updated: Date
    let etag: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case author = "author"
        case itemCreated = "created"
        case location = "geo"
        case permlink = "permlink"
        case title = "title"
        case created = "_created"
        case updated = "_updated"
        case etag = "_etag"
    }
}
