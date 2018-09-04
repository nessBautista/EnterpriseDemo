//
//  EnterpriseViewController.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class EnterpriseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableLateralMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: LATERAL MENU
    fileprivate func enableLateralMenu()
    {
        
        if self.revealViewController() != nil
        {
            let button: UIButton = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "iconMenu"), for: UIControlState())
            button.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            button.clipsToBounds = false
            
            let barButton = UIBarButtonItem(customView: button)
            navigationItem.setLeftBarButtonItems([barButton], animated: true)
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
}
