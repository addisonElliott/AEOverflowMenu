//
//  ViewController.swift
//  AEOverflowMenuDemo
//
//  Created by Social Local Mobile on 5/31/18.
//  Copyright © 2018 Addison Elliott. All rights reserved.
//

import UIKit
import AEOverflowMenu

class ViewController: UIViewController {
    var label: UILabel!
    var button: UIButton!
    var overflowMenu: AEOverflowMenu!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the layout programatically
        initLayout()
    }
    
    func initLayout() {
        view.backgroundColor = .white
        
        label = UILabel()
        label.text = "This is a test"
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
        
        button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(UIColor(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0), for: .normal)
        button.setTitleColor(UIColor(displayP3Red: 0.0, green: 0.478, blue: 1.0, alpha: 0.5), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        overflowMenu = AEOverflowMenu()
        overflowMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overflowMenu)
        
        overflowMenu.addItem("View Report", callback: viewReportClicked)
        overflowMenu.addItem("Settings")
        overflowMenu.addItem("Log Out")
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50.0).isActive = true
        
        overflowMenu.cornerAnchor = .BottomLeft
        overflowMenu.setup(self, button: button)
    }
    
    func viewReportClicked() {
        print("View report clicked")
    }
    
//    @objc func buttonClicked() {
//        // Show/toggle menu
//        overflowMenu.toggle()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

