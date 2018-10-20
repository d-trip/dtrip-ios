//
//  Router.swift
//  DTrip
//
//  Created by Artem Semavin on 21/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

protocol Router: Presentable {

    var _rootController: UINavigationController? { get }

    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)

    func popModule()
    func popModule(animated: Bool)
	func popModule(to module: Presentable)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool)

    func popToRootModule(animated: Bool)
}
