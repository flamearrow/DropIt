//
//  DropItView.swift
//  DropIt
//
//  Created by Chen Cen on 10/30/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class DropItView: NamedBezierPathView, UIDynamicAnimatorDelegate {
    private let dropBehavior = FallingObjectBehavior()
    
    private lazy var animator:UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    private var lastDrop:UIView?
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                // this will be constantly called when the attachment is being triggered
                // use it to update the bar between touch point and block
                // note here self and closure holds each other, need to unowned self
                attachment!.action = { [unowned self] in
                    if let attachedDrop = self.attachment!.items.first as? UIView {
                        self.bezierPaths[PathNames.Attachment] = UIBezierPath.lineFrom(from: self.attachment!.anchorPoint, to: attachedDrop.center)
                    }
                    
                }
            }
        }
    }
    
    // this is passed to a pane gesture recognizer, which trackers dragging gesture
    func grabDrop(recognizer: UIGestureRecognizer) {
        // when screen is touched, grab the view, create a UIAttachmentBehavior 
        // from the point touched to the last added view
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
            // when finger touches screen
            case .began:
                if let dropToAttachTo = lastDrop {
                    if dropToAttachTo.superview != nil {
                        attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
                    }
                    lastDrop = nil
                    bezierPaths[PathNames.Attachment] = nil

                }
            // when dragged
            case .changed:
                attachment?.anchorPoint = gesturePoint
            default:
                attachment = nil
        }
    }
    
    // this is called when UI animations stops
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    var animating: Bool = false {
        didSet {
            // start and stop animating by add/remove the behaviors
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    private struct PathNames {
        static let MiddleBarrier = "MiddleBarrier"
        static let Attachment = "Attachment"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
        dropBehavior.addBarrier(path: path, name: PathNames.MiddleBarrier)
        // set to the dic and redraw
        bezierPaths[PathNames.MiddleBarrier] = path
    }
    
    private let dropsPerRow = 10
    private var dropSize:CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    // ios coordinates starts from upper left of screen
    private func removeCompletedRow() {
        var dropsToRemove = [UIView]()
        // start from bottom left, search each row go up to top row(y == 0)
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        while hitTestRect.origin.y > bounds.minY {
            // left most block
            hitTestRect.origin.x = bounds.minX
            var dropsTested = 0
            var dropsFound = [UIView]()
            while dropsTested < dropsPerRow {
                if let hitView = hitTest(hitTestRect.mid) {
                    if hitView.superview == self {
                        dropsFound.append(hitView)
                    }
                }
                dropsTested += 1
                // move right
                hitTestRect.origin.x += dropSize.width
            }
            if dropsFound.count == dropsPerRow {
                dropsToRemove += dropsFound
            }
            // move up
            hitTestRect.origin.y -= dropSize.height
        }
        
        for drop in dropsToRemove {
            dropBehavior.removeItem(drop)
            drop.removeFromSuperview()
        }
        
    }
    
    func addDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.random
        
        addSubview(drop)
        // once added the animation started
        dropBehavior.addItem(drop)
        lastDrop = drop
    }

}
