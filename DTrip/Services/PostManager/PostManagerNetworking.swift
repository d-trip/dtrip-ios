//
//  PostManagerNetworking.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyConnect

protocol PostManagerNetworking {
    func getAllContent(page: Int) -> Observable<ContentResponseModel>
    func getContent(author: String, permlink: String) -> Observable<PostResponceResult>
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
                guard content.pages.hasNext else {
                    return Observable.just(content)
                }
                return Observable.just(content)
                    .concat(self.getAllContent(page: content.pages.current + 1))
        }
    }
    
    func getContent(author: String, permlink: String) -> Observable<PostResponceResult> {
        let request = Observable<Data>.create { [weak self] observer in
            guard let steem = self?.steem else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            steem.api.getContent(author: author, permlink: permlink) { (error, response) in
                if let error = error as? Error {
                    observer.onError(error)
                }
                if let response = response {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        observer.onNext(data)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
        
        return request
            .catchError(handleError)
            .map(to: PostResponceResult.self)
            .catchError(handleError)
    }
}
