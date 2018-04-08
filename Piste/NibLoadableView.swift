//
//  NibLoadableView.swift
//  Piste
//
//  Created by James Beattie on 13/08/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
