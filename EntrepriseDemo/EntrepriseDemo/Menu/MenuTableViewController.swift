//
//  MenuTableViewController.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 8/31/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    
    @IBOutlet weak var lblMaps: UILabel!
    @IBOutlet weak var lblReport: UILabel!
    
    @IBOutlet weak var lblLogout: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
        
    }
    
    fileprivate func loadConfig(){
        self.lblHome.text = "Home"
        self.lblNotes.text = "Notes"
        self.lblReport.text = "Reports"
        self.lblMaps.text = "Maps"
        self.lblLogout.text = "Logout"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - LATERAL MENU
    func closeMenu()
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
    }
    
    func pushFromRevealViewController(_ vc:UIViewController)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().pushFrontViewController(vc, animated: true)
        }
        
    }
    
    //MARK: - DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            print("Home")
            let vcHome: HomeViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            let navController = EnterpriseNavigationController(rootViewController: vcHome)
            self.pushFromRevealViewController(navController)
            self.closeMenu()
        case 1:
            print("Notes")
            let vcNotes: NotesViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            let navController = EnterpriseNavigationController(rootViewController: vcNotes)
            self.pushFromRevealViewController(navController)
            self.closeMenu()
        case 2:
            print("Reports")
            let vcNotes: ReportViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            let navController = EnterpriseNavigationController(rootViewController: vcNotes)
            self.pushFromRevealViewController(navController)
            self.closeMenu()
        case 3:
            print("MAPS")
            let vcMap: MapViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            let navController = EnterpriseNavigationController(rootViewController: vcMap)
            self.pushFromRevealViewController(navController)
            self.closeMenu()
        case 4:
            print("Logout")
            self.navigationController?.popToRootViewController(animated: true)
            self.closeMenu()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performLogout"), object: nil)
        default:
            break
        }
    }

}
