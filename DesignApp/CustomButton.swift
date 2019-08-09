//
//  CustomButton.swift
//  DesignApp
//
//  Created by Marc Phua on 08/07/19.
//  Copyright © 2019 marc. All rights reserved.
//

import UIKit

final class CustomButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 12.0
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = self.backgroundColor!.cgColor
            
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
}
