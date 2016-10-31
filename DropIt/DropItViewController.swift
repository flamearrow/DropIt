//
//  DropItViewController.swift
//  DropIt
//
//  Created by Chen Cen on 10/30/16.
//  Copyright © 2016 Chen Cen. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {
    @IBOutlet weak var dropItView: DropItView! {
        didSet {
            // add gesture recognizer programatically, note it self will be passed as a param to action
            dropItView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(recognizer:))))
        }
    }
    
    func addDrop(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            dropItView.addDrop()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dropItView.animating = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dropItView.animating = false
    }
}
