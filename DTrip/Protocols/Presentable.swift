//
//  Presentable.swift
//  DTrip
//
//  Created by Artem Semavin on 21/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
