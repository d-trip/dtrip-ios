//
//  ViewModel.swift
//  DTrip
//
//  Created by Artem Semavin on 25/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModel {
    associatedtype Action
    associatedtype State
    associatedtype Navigation
    
    var action: AnyObserver<Action> { get }
    var state: Observable<State> { get}
    var navigation: Observable<Navigation> { get }
}

extension ViewModel {
    deinit {
        Log.info("\(String(describing: self)) - \(#function)")
    }
}
