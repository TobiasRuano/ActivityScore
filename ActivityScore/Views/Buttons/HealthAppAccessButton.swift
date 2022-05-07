//
//  HealthAppAccessButton.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 12/03/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import UIKit

class HealthAppAccessButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func styleButton() {
//		imageView = UIImageView()
		imageView!.image = UIImage(named: "award")

//		self.addConstraints([
//			imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//			imageView?.centerYAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>, constant: <#T##CGFloat#>)
//		])
//		NSLayoutConstraint.activate([
//
//		])
	}

	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
