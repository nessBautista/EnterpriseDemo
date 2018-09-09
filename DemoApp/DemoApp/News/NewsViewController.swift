//
//  NewsViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//
/*
    THIS IS A PARENT CONTROLLER, IT WILL HOLD A CONTAINER CONNECTED TO A TABLEVIEWCONTROLLER
 
 */
import UIKit

class NewsViewController: DemoAppViewController {

    //MARK:- LYFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    //MARK:- LOAD CONFIGS
    fileprivate func loadConfig(){
        self.title = "News Feed"
    }
    
    //MARK:- NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
