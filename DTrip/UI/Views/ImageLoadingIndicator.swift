//
//  ImageLoadingIndicator.swift
//  DTrip
//
//  Created by Artem Semavin on 28/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit
import Kingfisher

final class ImageLoadingIndicator: Indicator {

    private var loadingView: LoadingView = {
        let size = CGSize(width: Spaces.quadruple, height: Spaces.quadruple)
        let frame = CGRect(origin: .zero, size: size)
        let view = LoadingView(frame: frame)
        view.sizeAnimation = size
        view.backgroundColor = .clear
        view.autoresizingMask = [.flexibleLeftMargin,
                                 .flexibleRightMargin,
                                 .flexibleBottomMargin,
                                 .flexibleTopMargin
                                ]
        return view
    }()
    
    var view: IndicatorView {
        return loadingView
    }
    
    var viewCenter: CGPoint = .zero {
        didSet {
            loadingView.center = viewCenter
            loadingView.updateViewCenter(viewCenter)
        }
    }
    
    func startAnimatingView() {
        loadingView.isHidden = false
        loadingView.startAnimation()
    }
    
    func stopAnimatingView() {
        loadingView.isHidden = true
        loadingView.stopAnimation()
    }
}
