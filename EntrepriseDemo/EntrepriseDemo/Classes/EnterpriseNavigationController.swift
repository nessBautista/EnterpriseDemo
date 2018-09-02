//
//  EnterpriseNavigationController.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 8/31/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class EnterpriseNavigationController: UINavigationController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationBar.barTintColor = .black
        self.navigationBar.isTranslucent  = false
        self.navigationBar.tintColor    = .white
        
        let navbarFont = UIFont(name: "HelveticaNeue-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navbarFont, NSAttributedStringKey.foregroundColor: UIColor.white]
    }


}
