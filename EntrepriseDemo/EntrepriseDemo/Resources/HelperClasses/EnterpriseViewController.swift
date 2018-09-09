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
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "performLogout"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.performLogout), name: NSNotification.Name(rawValue: "performLogout"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaultManager.getLoginStatus() == false {
            self.performLogout()
        }
    }
    
    @objc fileprivate func performLogout(){
        MessageManager.shared.showLoadingHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            UserDefaultManager.cleanUserDefaults()
            UserDefaultManager.setLogInStatus(status: false)
            let vcLogin: LoginViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            self.present(vcLogin, animated: true, completion: {MessageManager.shared.hideHUD()})
        })
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
    
    func printStoreLocation(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(documentsDirectory)
    }
}
