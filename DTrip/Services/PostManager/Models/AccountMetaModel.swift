//
//  AccountMetaModel.swift
//  DTrip
//
//  Created by Artem Semavin on 11/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct AccountMetaModel: Codable {
    let profile: AccountMetaProfile
    
    enum CodingKeys: String, CodingKey {
        case profile = "profile"
    }
}

struct AccountMetaProfile: Codable {
    let profileImage: String?
    let coverImage: String?
    let location: String?
    let name: String?
    let about: String?
    let github: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        case coverImage = "cover_image"
        case location = "location"
        case name = "name"
        case about = "about"
        case github = "github"
        case website = "website"
    }
}
