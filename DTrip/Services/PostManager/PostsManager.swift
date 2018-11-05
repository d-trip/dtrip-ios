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
    var content: Observable<[ContentModel]> { get }
    
    var disposeBag: DisposeBag { get }
}

final class PostManagerImp: PostManager {
    
    var content: Observable<[ContentModel]> {
        return contentSubject
    }
    
    private let contentSubject = ReplaySubject<[ContentModel]>.create(bufferSize: 1)
    
    let disposeBag = DisposeBag()
    let network: PostManagerNetworking
    
    init(network: PostManagerNetworking) {
        self.network = network
        
        getAllContent()
            .bind { [weak self] (content) in
                self?.contentSubject.onNext(content)
            }
            .disposed(by: disposeBag)
    }
    
    func getAllContent() -> Observable<[ContentModel]> {
        return network.getAllContent(page: 0)
            .scan([], accumulator: { (result, element) -> [ContentModel] in
                return result + element.results
            })
            .takeLast(1)
            .map { $0.filter { $0.type == .post } }
    }
}
