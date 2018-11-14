//
//  AccountModel.swift
//  DTrip
//
//  Created by Artem Semavin on 11/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct AccountModel {
    let name: String
    let profileImage: String?
    let coverImage: String?
    let about: String?
    let github: String?
    let website: String?
}

extension AccountModel: Equatable {
    static func == (lhs: AccountModel, rhs: AccountModel) -> Bool {
        return lhs.name == rhs.name
    }
}
