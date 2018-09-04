//
//  NewsItem.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/2/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsItem {

    let id: String
    let itemType:String
    let sectionId: String
    let sectionName: String
    var publicationDate: Date?
    let title: String
    let webUrl:String
    let apiUrl:String
    let thumbnail:String
    
    init(){
        self.id = String()
        self.itemType = String()
        self.sectionId = String()
        self.sectionName = String()
        self.title = String()
        self.webUrl = String()
        self.apiUrl = String()
        self.thumbnail = String()
    }
    
    
    init(json: JSON) {
        self.id = json["id"].string ?? String()
        self.itemType = json["type"].string ?? String()
        self.sectionId = json["sectionId"].string ?? String()
        self.sectionName = json["sectionName"].string ?? String()
        self.title = json["webTitle"].string ?? String()
        self.webUrl = json["webUrl"].string ?? String()
        self.apiUrl = json["apiUrl"].string ?? String()
        self.thumbnail = json["fields"]["thumbnail"].string ?? String()
    }
}
