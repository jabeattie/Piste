//
//  CustomFlowLayout.swift
//  Piste
//
//  Created by James Beattie on 08/04/2018.
//  Copyright © 2018 James Beattie. All rights reserved.
//

import UIKit

private let separatorDecorationView = "separator"

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        register(SeparatorView.self, forDecorationViewOfKind: separatorDecorationView)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let lineWidth = self.minimumLineSpacing
        var decorationAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let separatorAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorDecorationView, with: layoutAttribute.indexPath)
            let cellFrame = layoutAttribute.frame
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y - lineWidth, width: cellFrame.size.width, height: lineWidth)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }
        return layoutAttributes + decorationAttributes
    }
    
}
