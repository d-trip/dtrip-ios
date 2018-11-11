//
//  PostModel.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct PostModel {
    let id: Int
    let url: String
    let category: String
    let permlink: String
    let created: Date
    let lastUpdate: Date
    
    let title: String
    let bodyHTML: String
    let images: [String]
    let tags: [String]
    
    let author: AccountModel
    let votes: [String]
}

extension PostModel {
    func titleImage() -> String? {
        return images.first
    }
    
    func timeAgo() -> String? {
        return created.getElapsedInterval()
    }
}
