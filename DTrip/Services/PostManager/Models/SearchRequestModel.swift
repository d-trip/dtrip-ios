//
//  SearchRequestModel.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct SearchResponseModel: Codable {
    let results: [Result]
    let hits: Int
    let error: Bool
    let pages: Pages
    let time: Double
}

struct Pages: Codable {
    let hasNext, hasPrevious: Bool
    let current: Int
    
    enum CodingKeys: String, CodingKey {
        case hasNext = "has_next"
        case hasPrevious = "has_previous"
        case current
    }
}

struct Result: Codable {
    let permlink, created, title: String
    let children, netVotes: Int
    let tags: [String]
    let author: String
    let meta: Meta
    let type, summary: String
    
    enum CodingKeys: String, CodingKey {
        case permlink, created, title, children
        case netVotes = "net_votes"
        case tags, author, meta, type, summary
    }
}

struct Meta: Codable {
    let tags: [String]
    let location: Location
    let format, app, community: String
}

struct Location: Codable {
    let properties: Properties
    let geometry: Geometry
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

struct Properties: Codable {
    let name: String
}
