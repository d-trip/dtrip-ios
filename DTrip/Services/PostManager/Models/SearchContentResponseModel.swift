//
//  SearchRequestModel.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct SearchContentResponseModel: Codable {
    let results: [SearchContenResultModel]
    let hits: Int
    let error: Bool
    let pages: Pages
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
