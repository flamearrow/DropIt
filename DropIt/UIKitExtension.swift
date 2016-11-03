//
//  UIKitExtension.swift
//  DropIt
//
//  Created by Chen Cen on 10/30/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random(max:Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

extension UIColor {
    static var random: UIColor {
        switch arc4random() % 5 {
            case 0: return UIColor.blue
            case 1: return UIColor.green
            case 2: return UIColor.red
            case 3: return UIColor.orange
            case 4: return UIColor.purple
            default: return UIColor.black
        }
    }
}

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY)}
    var upperLeft: CGPoint { return CGPoint(x: minX, y: minY)}
    var lowerLeft: CGPoint { return CGPoint(x: minX, y: maxY)}
    var upperRight: CGPoint { return CGPoint(x: maxX, y: minY)}
    var lowerRight: CGPoint { return CGPoint(x: maxX, y: maxY)}
    
    // override a initializer
    init(center:CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        self.init(origin: upperLeft, size: size)
    }
}

extension UIView {
    // returns the block that covers this point
    func hitTest(_ p: CGPoint) -> UIView? {
        return hitTest(p, with: nil)
    }
}

extension UIBezierPath {
    class func lineFrom(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}


