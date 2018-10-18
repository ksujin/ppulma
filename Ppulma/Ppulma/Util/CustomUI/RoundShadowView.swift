//
//  RoundShadowView.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 19..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    var cornerRadius: CGFloat = 7.0
    var fillColor: UIColor = ColorChip.shared().mainPurple
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.15
            shadowLayer.shadowRadius = 4
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
