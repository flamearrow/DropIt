//
//  NamedBezierPathView.swift
//  DropIt
//
//  Created by Chen Cen on 11/2/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class NamedBezierPathView: UIView {
    
    var bezierPaths = [String:UIBezierPath]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // cheatingly iterate through dictionary values
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
    

}
