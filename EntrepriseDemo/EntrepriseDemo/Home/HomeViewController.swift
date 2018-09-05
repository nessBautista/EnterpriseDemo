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

    var newsTable: NewsTableViewController?
    deinit {
        print("deinit homeviewcontroller")
    }
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()


        
//        LibraryAPI.shared.bo.getTimeSeriesFor(equity: "MSFT", onSuccess: { (timeSeries) in
//
//        }) { (error) in
//            print(error)
//        }
        //Hide indicator
//        MessageManager.shared.showLoadingHUD()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//            
//            MessageManager.shared.hideHUD()
//            let vcLogin: LoginViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
//            self.present(vcLogin, animated: true, completion: nil)
//        })
    }

    
    
    fileprivate func loadConfig(){
        
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewsTableViewController" {
            if let news = segue.destination as? NewsTableViewController{
                self.newsTable = news
            }
            
        }
    }
 

}
