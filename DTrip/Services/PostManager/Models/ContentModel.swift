//
//  ContentModel.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct ContentModel: Codable {
    let permlink, created, title: String
    let children, netVotes: Int
    let tags: [String]
    let author: String
    let meta: MetaModel
    let type: TypeContent
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case permlink, created, title, children
        case netVotes = "net_votes"
        case tags, author, meta, type, summary
    }
}

struct MetaModel: Codable {
    let tags: [String]
    let location: LocationModel
    let format, app, community: String
}

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
}
