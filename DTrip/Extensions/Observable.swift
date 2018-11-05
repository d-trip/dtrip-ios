//
//  Observable.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    public func mapTo<R>(_ value: R) -> Observable<R> {
        return map { _ in value }
    }
    
    public func unwrap<T>() -> Observable<T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}

extension Observable {
    func asVoid() -> Observable<Void> {
        return self.map { (e) -> Void in
            return Void()
        }
    }
}

extension Observable where Element: Equatable {
    func ignore(value: Element) -> Observable<Element> {
        return filter { (e) -> Bool in
            return value != e
        }
    }
    
    func logError() -> Observable<Element> {
        return self.do(onError: { error in
            Log.handleError(error)
        })
    }
    
    func logServerError(message: String) -> Observable<Element> {
        return self.do(onError: { e in
            Log.handleError(e)
        })
    }
    
    func logNext(info: String) -> Observable<Element> {
        return self.do(onNext: { element in
            Log.info("\(info): \(element)")
        })
    }
}

extension ObservableType where E == Data {
    public func map<T>(to type: T.Type,
                       using decoder: JSONDecoder = JSONDecoder()) -> Observable<T> where T: Swift.Decodable {
        return map {
            try $0.map(to: type, using: decoder)
        }
    }
    
}
