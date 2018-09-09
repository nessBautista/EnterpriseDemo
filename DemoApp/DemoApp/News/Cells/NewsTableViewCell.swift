//
//  NewsTableViewCell.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/9/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!    
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblNews: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    //MARK: @loadCell    
    func loadCell(_ newsItem: NewsItem){
        self.img.setImageWithNoCache(urlString: newsItem.thumbnail, placeholder: UIImage(), onSuccess: nil)
        self.lblNews.text = newsItem.title 
        self.lblDate.text = newsItem.publicationDate?.getDateWithMonthName()
        self.lblSection.text = newsItem.sectionName
        self.lblSection.layer.cornerRadius = 4
        self.lblSection.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
