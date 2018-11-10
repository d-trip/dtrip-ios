//
//  ContentModel.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct SearchContenResulttModel: Codable {
    let permlink: String
    let created: String
    let title: String
    let children: Int
    let netVotes: Int
    let tags: [String]
    let author: String
    let meta: MetaJsonModel
    let type: ContentType
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case permlink, created, title, children
        case netVotes = "net_votes"
        case tags, author, meta, type, summary
    }
}
