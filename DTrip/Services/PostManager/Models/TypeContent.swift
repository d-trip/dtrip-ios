//
//  TypeContent.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

enum TypeContent: String, Codable {
    case post = "post"
    case other
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
            let typeString = try? container.decode(String.self) {
            self = TypeContent(typeString)
        } else {
            self = .other
        }
    }
    
    init(_ value: String) {
        switch value.lowercased() {
        case "post":
            self = .post
        default:
            self = .other
        }
    }
}
