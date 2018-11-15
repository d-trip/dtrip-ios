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
    var updateContent: AnyObserver<Void> { get }
    var content: Observable<[SearchContenResultModel]> { get }
    
    func getPost(identifier: PostIdentifier) -> Observable<PostModel>
    func getPosts(identifiers: [PostIdentifier]) -> Observable<[PostModel]>
    
    var disposeBag: DisposeBag { get }
}

final class PostManagerImp: PostManager {
    
    var updateContent: AnyObserver<Void> {
        return updateContentSubject.asObserver()
    }
    var content: Observable<[SearchContenResultModel]> {
        return contentSubject
    }
    
    private let contentSubject = ReplaySubject<[SearchContenResultModel]>.create(bufferSize: 1)
    private let updateContentSubject = PublishSubject<Void>()

    let disposeBag = DisposeBag()
    let network: PostManagerNetworking
    let parser: PostManagerParser
    
    init(network: PostManagerNetworking, parser: PostManagerParser) {
        self.network = network
        self.parser = parser

        updateContentSubject
            .startWith(())
            .flatMap(getAllContent)
            .bind { [weak self] (content) in
                self?.contentSubject.onNext(content)
            }
            .disposed(by: disposeBag)
    }
    
    func getAllContent() -> Observable<[SearchContenResultModel]> {
        return network.getAllContent(page: 0)
            .scan([]) { $0 + $1.results }
            .takeLast(1)
            .map { $0.filter { $0.type == .post } }
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
