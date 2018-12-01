//
//  PostsManager.swift
//  DTrip
//
//  Created by Artem Semavin on 21/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

protocol PostManager {
    func getContent(page: Int, limit: Int) -> Observable<SearchContentResponseModel>
    
    func getPost(identifier: PostIdentifier) -> Observable<PostModel>
    func getPosts(identifiers: [PostIdentifier]) -> Observable<[PostModel]>
    
    var disposeBag: DisposeBag { get }
}

final class PostManagerImp: PostManager {
    
    let disposeBag = DisposeBag()
    let network: PostManagerNetworking
    let parser: PostManagerParser
    
    init(network: PostManagerNetworking, parser: PostManagerParser) {
        self.network = network
        self.parser = parser
    }
    
    func getContent(page: Int, limit: Int) -> Observable<SearchContentResponseModel> {
        return network.getSearchContent(page: page, limit: limit)
    }
    
    func getPost(identifier: PostIdentifier) -> Observable<PostModel> {
        let postModel = network
            .getContent(author: identifier.author, permlink: identifier.permlink)
            .map { $0.result }
            .take(1)
        
        let accountsModel = network
            .getAccounts(accounts: [identifier.author])
            .map { $0.result }
            .take(1)
        
        return Observable.combineLatest(postModel, accountsModel)
            .flatMap(parser.makePostModel)
    }
    
    func getPosts(identifiers: [PostIdentifier]) -> Observable<[PostModel]> {
        let posts = identifiers.map(getPost)
        return Observable.merge(posts)
            .scan([]) { $0 + [$1] }
            .takeLast(1)
    }
}
