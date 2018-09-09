//
//  MenuTableViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    @IBOutlet weak var lblNews: UILabel!    
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblReport: UILabel!
    @IBOutlet weak var lblMaps: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            print("News")
            let vcNews: NewsViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            self.startNewFlowFromViewController(vcNews)
        case 1:
            print("Notes")
            let vcNotes: NotesViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            self.startNewFlowFromViewController(vcNotes)

        case 2:
            print("Reports")
            let vcReport: ReportViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            self.startNewFlowFromViewController(vcReport)
            
        case 3:
            print("MAPS")
            let vcMap: MapViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            self.startNewFlowFromViewController(vcMap)

        case 4:
            print("Logout")            
            self.closeMenu()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performLogout"), object: nil)
        default:
            break
        }
    }
    
    //MARK: @startNewFlow
    fileprivate func startNewFlowFromViewController(_ vc: UIViewController){
        let navController = DemoAppNavigationViewController(rootViewController: vc)
        self.pushFromRevealViewController(navController)
        self.closeMenu()
    }
    
    //MARK: - LATERAL MENU
    //MARK: @closeMenu
    func closeMenu()
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
    }
    
    //MARK: @pushFromReveal
    func pushFromRevealViewController(_ vc:UIViewController)
    {
        if self.revealViewController() != nil
        {
            self.revealViewController().pushFrontViewController(vc, animated: true)
        }
        
    }
}
