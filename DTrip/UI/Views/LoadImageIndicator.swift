//
//  LoadImageIndicator.swift
//  DTrip
//
//  Created by Artem Semavin on 14/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import Kingfisher

// ToDo: - Make a great loading indicator
struct ImageLoadingIndicator: Indicator {
    let view: UIView = UIView()
    
    func startAnimatingView() {
        view.isHidden = false
    }
    
    func stopAnimatingView() {
        view.isHidden = true
    }
    
    init() {
        view.backgroundColor = .red
    }
}
