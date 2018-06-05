//
//  ViewControllerFirst.swift
//  AEOverflowMenuDemo
//
//  Created by Social Local Mobile on 6/5/18.
//  Copyright © 2018 Addison Elliott. All rights reserved.
//

import UIKit
import AEOverflowMenu

class ViewControllerFirst: UIViewController {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var overflowMenu1: AEOverflowMenu!
    @IBOutlet weak var overflowMenu2: AEOverflowMenu!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overflowMenu1.addItem("No Callback Button")
        overflowMenu1.addItem("Item 1", callback: item1Pressed)
        overflowMenu1.addItem("Item 2 Longer Text Here", callback: item2Pressed)
        overflowMenu1.addItem("It", callback: item3Pressed)
        
//        overflowMenu2.addItem("No Callback Button")
//        overflowMenu2.addItem("Item 1", callback: item1Pressed)
//        overflowMenu2.addItem("Item 2 Longer Text Here", callback: item2Pressed)
//        overflowMenu2.addItem("It", callback: item3Pressed)
        
        // Setup the two overflow menus
//        overflowMenu1.setup(self, button: menuButton)
        overflowMenu1.setup(self, barButton: menuBarButton)
//        overflowMenu2.setup(self, barButton: menuBarButton)
        
        // Do any additional setup after loading the view.
    }
    
    func item1Pressed() {
        print("Item 1 Pressed")
    }
    
    func item2Pressed() {
        print("Item 2 Longer Text Here Pressed")
    }
    
    func item3Pressed() {
        print("It Pressed")
    }
}
