//
//  AccountResponseResultModel.swift
//  DTrip
//
//  Created by Artem Semavin on 11/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

struct NodeAccountModel: Codable {
    let id: Int
    let name: String
    let postCount: Int
    let commentCount: Int
    let canVote: Bool
    let votingPower: Int
    let balance: String
    let jsonMetadata: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case postCount = "post_count"
        case canVote = "can_vote"
        case votingPower = "voting_power"
        case commentCount = "comment_count"
        case name = "name"
        case balance = "balance"
        case jsonMetadata = "json_metadata"
    }
}

extension NodeAccountModel {
    func getMeta() -> AccountMetaModel? {
        guard let data = jsonMetadata.data(using: .utf8) else { return nil }
        do {
            let meta = try JSONDecoder().decode(AccountMetaModel.self, from: data)
            return meta
        } catch {
            Log.handleError(error)
            return nil
        }
    }
}

//    let reputation: String?
//    let proxy: String
//    let lastPost: String
//    let savingsSbdBalance: String
//    let owner: Active
//    let rewardSteemBalance: String
//    let transferHistory: [JSONAny]
//    let mined: Bool
//    let guestBloggers: [JSONAny]
//    let vestingBalance: String
//    let created: String
//    let witnessesVotedFor: Int
//    let toWithdraw: Int
//    let otherHistory: [JSONAny]
//    let marketHistory: [JSONAny]
//    let voteHistory: [JSONAny]
//    let curationRewards: Int
//    let lastAccountRecovery: String
//    let tagsUsage: [JSONAny]
//    let sbdLastInterestPayment: String
//    let savingsWithdrawRequests: Int
//    let pendingClaimedAccounts: Int

//    let lastOwnerUpdate: String
//    let savingsSbdLastInterestPayment: String
//    let savingsSbdSecondsLastUpdate: String
//    let receivedVestingShares: String
//    let lifetimeVoteCount: Int
//    let rewardVestingBalance: String
//    let sbdBalance: String
//    let lastRootPost: String
//    let proxiedVsfVotes: [Int]
//    let postBandwidth: Int
//    let delegatedVestingShares: String
//    let rewardSbdBalance: String
//    let witnessVotes: [String]
//    let postingRewards: Int
//    let sbdSecondsLastUpdate: String
//    let withdrawn: Int
//    let postHistory: [JSONAny]
//    let posting: Active
//    let memoKey: String
//    let lastVoteTime: String
//    let savingsBalance: String
//    let withdrawRoutes: Int
//    let lastAccountUpdate: String
//    let savingsSbdSeconds: String
//    let recoveryAccount: String
//    let resetAccount: String
//    let nextVestingWithdrawal: String
//    let sbdSeconds: String
//    let votingManabar: VotingManabar
//    let rewardVestingSteem: String
//    let vestingShares: String
//    let vestingWithdrawRate: String

