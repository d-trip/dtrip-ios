//
//  PostResponceResult.swift
//  DTrip
//
//  Created by Artem Semavin on 08/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct NodeContentResponseModel: Codable {
    let id: Int
    let jsonrpc: String
    let result: NodeContentModel
}
