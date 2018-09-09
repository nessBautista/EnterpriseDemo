//
//  DemoAppViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit

class DemoAppViewController: UIViewController {

    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup lateral menu
        self.setupLateralMenu()
        
        //subscribe to logout
        self.subscribeToLogout()
    }

    //MARK: @setupLat/ LATERAL MENU
    fileprivate func setupLateralMenu()
    {
        if self.revealViewController() != nil
        {
            //Create Home Menu Button
            let button: UIButton = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "iconMenu"), for: UIControlState())
            button.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            button.clipsToBounds = false
            let barButton = UIBarButtonItem(customView: button)
            navigationItem.setLeftBarButtonItems([barButton], animated: true)
            //Adding gesture recognizers to remove lateral menu
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //MARK: @subscribeToLogout/ Subscribe to logout by local notifications
    fileprivate func subscribeToLogout()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "performLogout"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.performLogout), name: NSNotification.Name(rawValue: "performLogout"), object: nil)
    }
    
    //MARK: @performLogout/ Do logout and clean user defaults
    @objc fileprivate func performLogout(){
        MessageManager.shared.showLoadingHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            UserDefaultManager.cleanUserDefaults()
            UserDefaultManager.setLogInStatus(status: false)
            let vcLogin: LoginViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            self.present(vcLogin, animated: true, completion: {MessageManager.shared.hideHUD()})
        })
    }
}
