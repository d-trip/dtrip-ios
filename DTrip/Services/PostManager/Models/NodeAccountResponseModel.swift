//
//  AccountResponseModel.swift
//  DTrip
//
//  Created by Artem Semavin on 11/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.

import Foundation

struct NodeAccountResponseModel: Codable {
    let jsonrpc: String
    let result: [NodeAccountModel]
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case jsonrpc = "jsonrpc"
        case result = "result"
        case id = "id"
    }
}
