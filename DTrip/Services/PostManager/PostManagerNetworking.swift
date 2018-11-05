//
//  PostManagerNetworking.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

protocol PostManagerNetworking {
    func getAllContent(page: Int) -> Observable<ContentResponseModel>
}

extension Networking: PostManagerNetworking {
    func getContent(page: Int) -> Observable<ContentResponseModel> {
        let parameters: [String: Any] = ["q": "meta.app:dtrip AND meta.location.geometry.type:Point",
                                         "include": "meta",
                                         "pg": page]
        
        return request(url: searchURL, method: .get, parameters: parameters)
            .retry(2)
            .catchError(handleError)
            .map(to: ContentResponseModel.self)
            .catchError(handleError)
    }
    
    func getAllContent(page: Int) -> Observable<ContentResponseModel> {
        
        // ToDo: - Now it's sync operations. not very fast:(
        return getContent(page: page)
            .flatMap { content -> Observable<ContentResponseModel> in
                guard content.pages.hasNext else { return .empty() }
                return Observable<ContentResponseModel>.just(content)
                    .concat(self.getAllContent(page: content.pages.current + 1))
        }
    }
}
