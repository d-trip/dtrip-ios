//
//  PostCollectionViewLoadingCell.swift
//  DTrip
//
//  Created by Artem Semavin on 15/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

final class PostTableViewLoadingCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
    }
}

