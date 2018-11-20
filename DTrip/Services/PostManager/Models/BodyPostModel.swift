//
//  BodyPostModel.swift
//  DTrip
//
//  Created by Artem Semavin on 21/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct BodyPostModel: Decodable {
    let html: String
    let mutate: Bool
    let hashtags: [String]
    let usertags: [String]
    let htmltags: [String]
    let images: [String]
    let links: [String]
}
