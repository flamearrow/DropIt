//
//  FallingObjectBehavior.swift
//  DropIt
//
//  Created by Chen Cen on 10/30/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class FallingObjectBehavior: UIDynamicBehavior {
    private let gravity = UIGravityBehavior()
    // don't fall out of bounds, more boundaries can be added later
    private let collider:UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    private let itemBehavior:UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        // if rotating, y axis won't move
        dib.allowsRotation = true
        // energy loss, how much it's going to bounce back
        dib.elasticity = 0.05
        return dib
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    func addBarrier(path: UIBezierPath, name:String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func addItem(_ item:UIDynamicItem) {
        gravity.addItem(item)
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(_ item:UIDynamicItem) {
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehavior.removeItem(item)
    }
}
