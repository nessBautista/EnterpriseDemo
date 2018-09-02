//
//  HomeViewController.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 8/31/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import Alamofire
class HomeViewController: EnterpriseViewController {

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()

        var params:[String:Any] = [:]
        params["function"] = "TIME_SERIES_MONTHLY"
        params["apikey"] = "1730BP20UVXJEPF0"
        params["symbol"] = "AAPL0"
        LibraryAPI.shared.bo.requestService(service: "", methodType: .get, parameters: params, onSuccess: {json in
            
        }, onError: {error in
            
        })
        //Hide indicator
//        MessageManager.shared.showLoadingHUD()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//            
//            MessageManager.shared.hideHUD()
//            let vcLogin: LoginViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
//            self.present(vcLogin, animated: true, completion: nil)
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func loadConfig(){
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
