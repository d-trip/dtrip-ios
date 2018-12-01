//
//  SearchRequestModel.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct SearchContentResponseModel: Codable {
    let items: [SearchContenItemModel]
    let meta: SearchContentMeta
    
    enum CodingKeys: String, CodingKey {
        case items = "_items"
        case meta = "_meta"
    }
}

struct SearchContentMeta: Codable {
    let page: Int
    let maxResults: Int
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case maxResults = "max_results"
        case total
    }
}
