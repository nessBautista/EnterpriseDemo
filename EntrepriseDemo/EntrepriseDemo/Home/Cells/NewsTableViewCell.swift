//
//  NewsTableViewCell.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell,  URLSessionDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblSection: UILabel!    
    @IBOutlet weak var lblNews: UILabel!
    @IBOutlet weak var lblPublicationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    
    func loadCell(_ newsItem: NewsItem){
        self.img.setImageWithNoCache(urlString: newsItem.thumbnail, placeholder:UIImage(), onSuccess:nil)
        self.lblNews.text = newsItem.title
        self.lblPublicationDate.adjustsFontSizeToFitWidth = true
        self.lblPublicationDate.text = newsItem.publicationDate?.getDateAndTime() ?? String()
        
        self.lblSection.text = newsItem.sectionName
        self.lblSection.layer.cornerRadius = 3.0
        self.lblSection.clipsToBounds = true
    }
    
    
    
}


