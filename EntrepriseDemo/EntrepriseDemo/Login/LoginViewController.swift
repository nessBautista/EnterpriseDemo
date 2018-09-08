//
//  LoginViewController.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
        guard let user = self.txtUser.text, let password = self.txtPassword.text else {
            return
        }
        
        MessageManager.shared.showLoadingHUD()
        self.login(user: user, password: password, onSuccess: { success, response in
            if success == true {
                UserDefaultManager.setLogInStatus(status: success)
                UserDefaultManager.saveUserDefaults(dict: response)
                self.dismiss(animated: true, completion: {
                    MessageManager.shared.hideHUD()
                })
            }
        })
    }
    
   
    fileprivate func login(user:String, password: String, onSuccess:@escaping ((_ success:Bool,_ dict:[String:String])->())){
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            
            var response:[String:String] = [:]
            response[Defaults.kUserName.rawValue] = user
            response[Defaults.kPassword.rawValue] = password
            response[Defaults.kTheGuardian.rawValue] = "4134ccef-13e1-45df-b406-7423ad88cd12"
            response[Defaults.kFinance.rawValue] = "1730BP20UVXJEPF0"
            
            onSuccess(true, response)
        })
    }

}
