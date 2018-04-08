//
//  SeparatorView.swift
//  Piste
//
//  Created by James Beattie on 08/04/2018.
//  Copyright © 2018 James Beattie. All rights reserved.
//

import UIKit

class SeparatorView: UICollectionReusableView {
    
    var background: UIView
    
    override init(frame: CGRect) {
        print(frame)
        background = UIView(frame: CGRect(x: 8, y: 0, width: frame.size.width - 16, height: frame.size.height))
        super.init(frame: frame)
        addSubview(background)
        background.backgroundColor = UIColor.pisteRed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}
