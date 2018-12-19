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
import CoreLocation

protocol PostManagerNetworking {
    func getAccounts(accounts: [String]) -> Observable<NodeAccountResponseModel>
    func getSearchContent(page: Int, limit: Int) -> Observable<SearchContentResponseModel>
    func getContent(author: String, permlink: String) -> Observable<NodeContentResponseModel>
    func getSearchContent(page: Int,
                          limit: Int,
                          bottomLeft: CLLocationCoordinate2D,
                          topRight: CLLocationCoordinate2D) -> Observable<SearchContentResponseModel>
}

extension Networking: PostManagerNetworking {
    func getSearchContent(page: Int,
                          limit: Int,
                          bottomLeft: CLLocationCoordinate2D,
                          topRight: CLLocationCoordinate2D) -> Observable<SearchContentResponseModel> {
        let sortString = "-created"
        let whereString = """
        {
            "geo.geometry.coordinates": {
                "$geoWithin": {
                    "$box": [[\(bottomLeft.longitude), \(bottomLeft.latitude)], [\(topRight.longitude),\(topRight.latitude)]]
                }
            }
        }
        """
        let parameters: [String: Any] = ["where": whereString,
                                         "page": page,
                                         "max_results": limit,
                                         "sort": sortString]
        
        return request(url: searchPostURL, method: .get, parameters: parameters)
            .retry(2)
            .catchError(handleError)
            .map(to: SearchContentResponseModel.self)
            .catchError(handleError)
    }
    
    func getSearchContent(page: Int, limit: Int) -> Observable<SearchContentResponseModel> {
        let sortString = "-created"
        let parameters: [String: Any] = ["page": page,
                                         "max_results": limit,
                                         "sort": sortString]
        
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
