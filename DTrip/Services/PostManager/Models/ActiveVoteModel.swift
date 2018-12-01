//
//  ActiveVote.swift
//  DTrip
//
//  Created by Artem Semavin on 08/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct ActiveVoteModel: Codable {
    let time: Date
    let voter: String
    let weight: Int
//    let rshares: Int
    let percent: Int
    let reputation: Reputation?
}
