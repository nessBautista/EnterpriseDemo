//
//  NewsTableViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/9/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    //MARK: - VARIABLES AND OUTPUTS
    fileprivate var pagination = Pagination()
    fileprivate var news:[NewsItem] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
        self.getNews()
    }
    
    //MARK: - LOADS
    fileprivate func loadConfig(){
        self.setRefreshControl()
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")

    }
    
    //MARK: - WEB SERVICES
    fileprivate func getNews(){
        //Construct Request
        var params:[String:Any] = [:]
        params["api-key"] = Constants.ApiKey.kTheGuardian
        params["show-fields"] = "thumbnail"
        params["page"] = self.pagination.currentPage + 1
        
        //Request Service
        NetworkManager.shared.getNewsFeed(params,onSuccess: { (newsItems, pagination) in
            //Update Data Model
            print(newsItems.count)
            self.news  += newsItems
            self.pagination = pagination
            
            //Update UI
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.refreshControl?.setLastUpdate()
        }) { (error) in
            MessageManager.shared.showStatusBar(title: "Error", type: .error, containsIcon: false)
        }
    }
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = self.news[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell
        cell?.loadCell(item)
        return cell ?? UITableViewCell()
        //return self.getBasicNewsCell(indexPath)
        //return self.getNewsCellWithDetailLabel(indexPath)
    }
    
    //MARK: - TABLE DELEGATES
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = self.news[row]
        let vcDetail: NewsDetailViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
        vcDetail.strURL = item.webUrl
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCellRow = self.news.count - 1
        if indexPath.row == lastCellRow && self.tableView.contentOffset.y > 0 {
            self.getNews()
        }
    }
    //MARK: @setRefreshControl
    fileprivate func setRefreshControl(){
        //Create refresh control
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.reloadTable),for: UIControlEvents.valueChanged)
        self.tableView.refreshControl?.setLastUpdate()
        
    }
    @objc fileprivate func reloadTable(){
        self.news = []
        self.getNews()
    }
    
    //MARK: @getBasicNewsCell
    fileprivate func getBasicNewsCell(_ indexPath: IndexPath)-> UITableViewCell {
        let row = indexPath.row
        let item = self.news[row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = item.title
        
        return cell ?? UITableViewCell()
    }
    
    //MARK: @getNewsCellWithDetailLabel
    fileprivate func getNewsCellWithDetailLabel(_ indexPath: IndexPath)-> UITableViewCell {
        //**** Should use delegate for row height and make sure identifier is Cell in MainStoryboard
        let cell = UITableViewCell(style: .value1, reuseIdentifier:"Cell")
        let row = indexPath.row
        let item = self.news[row]
        cell.textLabel?.text = item.publicationDate?.getDateSimple()
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = item.title
        return cell
    }
    
    
}
