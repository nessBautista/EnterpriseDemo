//
//  NewsTableViewController.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/4/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    fileprivate var pagination = Pagination()
    fileprivate var news:[NewsItem] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNews()
    }

    // MARK: - WEB SERVICES
    fileprivate func getNews(){
        var params:[String:Any] = [:]
        params["api-key"] = Constants.ApiKey.kTheGuardian
        params["show-fields"] = "thumbnail"
        params["page"] = self.pagination.currentPage + 1
        LibraryAPI.shared.bo.getNewsFeed(params,onSuccess: { (newsItems, pagination) in
            
            print(newsItems.count)
            self.news  += newsItems
            self.pagination = pagination
        }) { (error) in
            
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.news[indexPath.row]
        let cell =  self.tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = item.title
        cell?.textLabel?.numberOfLines = 0
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.news[indexPath.row]
        let vcNotes: NewsDetailTableViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
        vcNotes.strURL = item.webUrl
        self.navigationController?.pushViewController(vcNotes, animated: true)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let itemIdxs = self.news.count - 1
        if row == itemIdxs {
            self.getNews()
        }
    }
    
}
