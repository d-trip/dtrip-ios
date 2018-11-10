//
//  PostManagerParser.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

protocol PostManagerParser {
    func makePostModel(_ content: NodeContentModel) -> Observable<PostModel>
}

final class PostManagerParserImp: PostManagerParser {
    func makePostModel(_ content: NodeContentModel) -> Observable<PostModel> {
        return Observable.create({ observer -> Disposable in
            let postModel = PostModel.init(id: content.id,
                                           url: content.url,
                                           author: content.author,
                                           category: content.category,
                                           permlink: content.permlink,
                                           created: content.created,
                                           lastUpdate: content.lastUpdate,
                                           title: content.title,
                                           bodyHTML: content.body,
                                           images: [],
                                           tags: [])
            
            observer.onNext(postModel)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
