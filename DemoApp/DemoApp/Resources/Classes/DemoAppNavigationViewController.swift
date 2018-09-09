//
//  DemoAppNavigationViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit

class DemoAppNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = .black
        self.navigationBar.isTranslucent  = false
        self.navigationBar.tintColor    = .white
        let navbarFont = UIFont(name: "HelveticaNeue-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navbarFont, NSAttributedStringKey.foregroundColor: UIColor.white]
    }

}
