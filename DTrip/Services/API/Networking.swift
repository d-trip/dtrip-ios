//
//  Networking.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyConnect

final class Networking {
 
    let searchURL: String = Parameters.API.searchURL
    let steem = Steem.sharedInstance
    
    init() {
        configureSteem()
    }
    
    func configureSteem() {
        steem.initialize(config: ["api": Parameters.API.steemURL])
    }
    
    func request(url: URLConvertible,
                 method: HTTPMethod,
                 parameters: Alamofire.Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> Observable<Data> {
        
        let encoding: ParameterEncoding
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }

        return Observable.create { observer in
            let request = SessionManager.default.request(url,
                                                         method: method,
                                                         parameters: parameters,
                                                         encoding: encoding,
                                                         headers: headers)
            request.responseData { response in
                if let error = response.error {
                    observer.onError(error)
                } else if let data = response.data {
                    observer.onNext(data)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func handleError<T>(_ error: Error) -> Observable<T> {
        Log.handleError(error)
        return Observable.empty()
    }
}
