//
//  MapClusterMarkerView.swift
//  DTrip
//
//  Created by Artem Semavin on 07/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import MapKit

final class MapClusterMarkerView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        didSet {
            configure(with: annotation)
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = Constants.centerOffset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
    
    private func configure(with annotation: MKAnnotation?) {
        guard let annotation = annotation as? MKClusterAnnotation else { return }
    
        let renderer = UIGraphicsImageRenderer(size: Constants.sizeView)
    
        image = renderer.image { _ in
            UIColor.blue.setFill()
            
            let rectOval = CGRect(origin: CGPoint.zero, size: Constants.sizeView)
            UIBezierPath(ovalIn: rectOval).fill()
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: Constants.font]
            let text = "\(annotation.memberAnnotations.count)"
            let textSize = text.size(withAttributes: attributes)
            let rectText = CGRect(x: Constants.sizeView.width / 2 - textSize.width / 2,
                                  y: Constants.sizeView.height / 2 - textSize.height / 2,
                                  width: textSize.width,
                                  height: textSize.height)
            text.draw(in: rectText, withAttributes: attributes)
        }
        
        detailCalloutAccessoryView = nil
        canShowCallout = false
    }
}

extension MapClusterMarkerView {
    enum Constants { 
        static let sizeView = CGSize(width: 40, height: 40)
        static let font: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
}
