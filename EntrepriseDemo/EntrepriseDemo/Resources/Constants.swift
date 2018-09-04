//
//  Constants.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

enum StoryboardsIds: String {
    case main = "Main"
    
}

struct Constants {
    static let kFinanceApi = "https://www.alphavantage.co/query"
    static let kTheGuardianApi = "https://content.guardianapis.com/search"
    
    static let  guardian = "https://content.guardianapis.com/search?api-key=4134ccef-13e1-45df-b406-7423ad88cd12&show-fields=thumbnail"
    
    struct ApiKey {
        static let kAlphavantage = "1730BP20UVXJEPF0"
        static let kTheGuardian = "4134ccef-13e1-45df-b406-7423ad88cd12"
    }
    
    struct services {
        static let timeSeriesByMonth = "TIME_SERIES_MONTHLY"
        static let foreignExchange = ""
    }
}
