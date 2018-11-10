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
    var content: Observable<[SearchContenResulttModel]> { get }
    
    func getPost(author: String, permlink: String) -> Observable<PostModel>
    func getPosts(filter: [(author: String, permlink: String)]) -> Observable<[PostModel]>
    
    var disposeBag: DisposeBag { get }
}

final class PostManagerImp: PostManager {
    
    let updateContent: AnyObserver<Void>
    var content: Observable<[SearchContenResulttModel]> {
        return contentSubject
    }
    
    private let contentSubject = ReplaySubject<[SearchContenResulttModel]>.create(bufferSize: 1)
    
    let disposeBag = DisposeBag()
    let network: PostManagerNetworking
    let parser: PostManagerParser
    
    init(network: PostManagerNetworking, parser: PostManagerParser) {
        self.network = network
        self.parser = parser
        
        let updateContentSubject = PublishSubject<Void>()
        updateContent = updateContentSubject.asObserver()
        
        updateContentSubject
            .startWith(())
            .flatMap(getAllContent)
            .bind { [weak self] (content) in
                self?.contentSubject.onNext(content)
            }
            .disposed(by: disposeBag)
    }
    
    func getAllContent() -> Observable<[SearchContenResulttModel]> {
        return network.getAllContent(page: 0)
            .scan([]) { $0 + $1.results }
            .takeLast(1)
            .map { $0.filter { $0.type == .post } }
    }
    
    func getPost(author: String, permlink: String) -> Observable<PostModel> {
        return network
            .getContent(author: author, permlink: permlink)
            .map { $0.result }
            .flatMap(parser.makePostModel)
    }
    
    func getPosts(filter: [(author: String, permlink: String)]) -> Observable<[PostModel]> {
        let posts = filter.map(getPost)
        return Observable.merge(posts)
            .scan([]) { $0 + [$1] }
            .takeLast(1)
    }
}
