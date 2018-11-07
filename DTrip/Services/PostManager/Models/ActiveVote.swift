//
//  ActiveVote.swift
//  DTrip
//
//  Created by Artem Semavin on 08/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct ActiveVote: Codable {
    let time: Date
    let voter: String
    let weight: Int
    let rshares: Int
    let percent: Int
    let reputation: Reputation
}

enum Reputation: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Reputation.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Reputation"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
