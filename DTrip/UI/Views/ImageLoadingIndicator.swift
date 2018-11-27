//
//  ImageLoadingIndicator.swift
//  DTrip
//
//  Created by Artem Semavin on 28/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit
import Kingfisher

struct ImageLoadingIndicator: Indicator {
    
    private var loadingView: LoadingView = {
        let view = LoadingView()
        view.backgroundColor = .red
        view.sizeAnimation = CGSize(width: Spaces.quadruple, height: Spaces.quadruple)
        return view
    }()
    
    var view: IndicatorView {
        return self.loadingView
    }

    func startAnimatingView() {
        loadingView.startAnimation()
    }
    
    func stopAnimatingView() {
        loadingView.stopAnimation()
    }
}
