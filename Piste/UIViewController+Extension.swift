//
//  UIViewController+Extension.swift
//  Piste
//
//  Created by James Beattie on 08/04/2018.
//  Copyright © 2018 James Beattie. All rights reserved.
//

import UIKit

extension UIViewController {
    func addGradientView() {
        let gradientLayer = CAGradientLayer()
        
        let screenBounds = UIScreen.main.bounds
        gradientLayer.frame = screenBounds
        let color1 = UIColor(red: 255 / 255.0, green: 66 / 255.0, blue: 36 / 255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 255 / 255.0, green: 0 / 255.0, blue: 76 / 255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
