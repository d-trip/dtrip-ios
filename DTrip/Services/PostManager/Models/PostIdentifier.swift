//
//  PostIdentifier.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct PostIdentifier {
    let author: String
    let permlink: String
    
    init(_ author: String, _ permlink: String) {
        self.author = author
        self.permlink = permlink
    }
}

extension PostIdentifier: Hashable {
    var hashValue: Int {
        return (author + permlink).hashValue
    }
}

extension PostIdentifier: Equatable {
    static func == (lhs: PostIdentifier, rhs: PostIdentifier) -> Bool {
        return lhs.author == rhs.author &&
            lhs.permlink == rhs.permlink
    }
}
