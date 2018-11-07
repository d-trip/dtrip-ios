//
//  PostModel.swift
//  DTrip
//
//  Created by Artem Semavin on 08/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    let id: Int
    let created: Date
    let lastUpdate: Date
    let url: String
    
    let category: String
    let author: String
    let permlink: String
    let title: String
    let body: String
    let activeVotes: [ActiveVote]
    
    let jsonMetadata: String
    
    enum CodingKeys: String, CodingKey {
        case id, permlink, created
        case title, url, category, author, body
        case lastUpdate = "last_update"
        case jsonMetadata = "json_metadata"
        case activeVotes = "active_votes"
    }
    
//    let bodyLength: Int
//    let percentSteemDollars: Int
//    let voteRshares: Int
//    let maxCashoutTime: Date
//    let cashoutTime: Date
//
//    let curatorPayoutValue: String
//    let allowVotes: Bool
//    let pendingPayoutValue: String
//
//    let totalPendingPayoutValue: String
//    let lastPayout: Date
//    let childrenAbsRshares: Int
//
//    let parentPermlink: String
//
//    let netVotes: Int
//    let rootPermlink: String
//    let rewardWeight: Int
//    let parentAuthor: String
//    let children: Int
//    let netRshares: Int
//    let rootAuthor: String
//    let allowCurationRewards: Bool
//    let rootTitle: String
//
//    let promoted: String
//    let active: Date
//    let depth: Int
//
//    let maxAcceptedPayout: String
//    let authorReputation: String
//    let totalVoteWeight: Int
//    let allowReplies: Bool
//    let absRshares: Int
//
//    let totalPayoutValue: String
//    let authorRewards: Int
    
//    let rebloggedBy: [String?]
//    let replies: [String?]
//    let beneficiaries: [String?]
}

extension PostModel {
    func getMetadata() -> MetaModel? {
        guard let data = jsonMetadata.data(using: .utf8) else { return nil }
        do {
            let meta = try JSONDecoder().decode(MetaModel.self, from: data)
            return meta
        } catch {
            Log.handleError(error)
            return nil
        }
    }
}
