//
//  LineView.swift
//  Weight
//
//  Created by Tobias Ruano on 13/03/2018.
//  Copyright © 2018 Trotos. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    
    let VC = ScoreViewController()
    
    var arrayLocal = [0, 0, 0, 0, 0, 0, 0]
    func setArrayScore() {
        var position = 0
        
        while UserDefaults.standard.value(forKey: "arrayScore\(position)") != nil {
            let num = UserDefaults.standard.integer(forKey: "arrayScore\(position)")
            arrayLocal[position] = num
            position += 1
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        setArrayScore()
        Graphs .draw_7PointLine(
            point0Value: CGFloat(arrayLocal[0]),
            point1Value: CGFloat(arrayLocal[1]),
            point2Value: CGFloat(arrayLocal[2]),
            point3Value: CGFloat(arrayLocal[3]),
            point4Value: CGFloat(arrayLocal[4]),
            point5Value: CGFloat(arrayLocal[5]),
            point6Value: CGFloat(arrayLocal[6]),
            lineWidth: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
