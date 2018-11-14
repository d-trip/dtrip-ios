//
//  PostManagerParser.swift
//  DTrip
//
//  Created by Artem Semavin on 10/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

enum PostManagerParserError: Error {
    case authorModelIsNotFound
}

protocol PostManagerParser {
    func makePostModel(_ content: NodeContentModel, _ accounts: [NodeAccountModel]) -> Observable<PostModel>
}

final class PostManagerParserImp: PostManagerParser {
    func makePostModel(_ content: NodeContentModel, _ accounts: [NodeAccountModel]) -> Observable<PostModel> {
        return Observable.create({ observer -> Disposable in
            guard let authorNodeModel = accounts.first(where: { $0.name == content.author }) else {
                observer.onError(PostManagerParserError.authorModelIsNotFound)
                return Disposables.create()
            }
            let authorMeta = authorNodeModel.getMeta()?.profile
            let postMeta = content.getMeta()
            
            let author = AccountModel(name: authorNodeModel.name,
                                      profileImage: authorMeta?.profileImage,
                                      coverImage: authorMeta?.coverImage,
                                      about: authorMeta?.about,
                                      github: authorMeta?.github,
                                      website: authorMeta?.website)
            
            let postModel = PostModel(id: content.id,
                                      url: content.url,
                                      category: content.category,
                                      permlink: content.permlink,
                                      created: content.created,
                                      lastUpdate: content.lastUpdate,
                                      title: content.title,
                                      description: "",
                                      location: postMeta?.location.properties.name,
                                      bodyHTML: content.body,
                                      images: [],
                                      tags: postMeta?.tags ?? [],
                                      author: author,
                                      votes: content.activeVotes.map { $0.voter })
            observer.onNext(postModel)
            observer.onCompleted()
            return Disposables.create()
        })
    }
}
