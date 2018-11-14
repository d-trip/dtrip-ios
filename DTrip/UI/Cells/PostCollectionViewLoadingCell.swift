//
//  PostCollectionViewLoadingCell.swift
//  DTrip
//
//  Created by Artem Semavin on 15/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

class PostCollectionViewLoadingCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = .green
    }
}

