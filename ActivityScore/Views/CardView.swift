//
//  CardView.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 16/3/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var shadowOffsetHeight: CGFloat = 0
    @IBInspectable var shadowOffsetWith: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = UIColor.gray
    @IBInspectable var shadowOpacity: CGFloat = 0.2

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
		layer.shadowRadius = 15
        layer.shadowOffset = CGSize(width: shadowOffsetWith, height: shadowOffsetHeight)

        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
