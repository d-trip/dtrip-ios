//
//  PostSectionItem.swift
//  DTrip
//
//  Created by Artem Semavin on 13/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import protocol DifferenceKit.Differentiable

enum PostItem {
    case postItem(post: PostModel)
    case loadingItem(title: String, animate: Bool)
}

extension PostItem: Differentiable {
    typealias DifferenceIdentifier = String

    var differenceIdentifier: PostItem.DifferenceIdentifier {
        switch self {
        case .postItem(post: let post):
            return post.permlink + post.author.name
        case .loadingItem(title: let title, animate: _):
            return title
        }
    }
    
    func isContentEqual(to source: PostItem) -> Bool {
        return self == source
    }
}

extension PostItem: Equatable {
    static func == (lhs: PostItem, rhs: PostItem) -> Bool {
        switch (lhs, rhs) {
        case let (.postItem(lhsPost), .postItem(rhsPost)):
            return lhsPost == rhsPost
        default:
            return false
        }
    }
}
