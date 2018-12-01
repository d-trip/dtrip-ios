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
    func getAccounts(accounts: [String]) -> Observable<NodeAccountResponseModel>
    func getSearchContent(page: Int, limit: Int) -> Observable<SearchContentResponseModel>
    func getContent(author: String, permlink: String) -> Observable<NodeContentResponseModel>
}

extension Networking: PostManagerNetworking {
    func getSearchContent(page: Int, limit: Int) -> Observable<SearchContentResponseModel> {
        let parameters: [String: Any] = ["page": page, "max_results": limit]
        
        return request(url: searchPostURL, method: .get, parameters: parameters)
            .retry(2)
            .catchError(handleError)
            .map(to: SearchContentResponseModel.self)
            .catchError(handleError)
    }
    
    func getContent(author: String, permlink: String) -> Observable<NodeContentResponseModel> {
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
            .map(to: NodeContentResponseModel.self)
            .catchError(handleError)
    }
    
    func getAccounts(accounts: [String]) -> Observable<NodeAccountResponseModel> {
        let request = Observable<Data>.create { [weak self] observer in
            guard let steem = self?.steem else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            steem.api.getAccounts(accounts: accounts) { (error, response) in
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
            .map(to: NodeAccountResponseModel.self)
            .catchError(handleError)
    }
}
