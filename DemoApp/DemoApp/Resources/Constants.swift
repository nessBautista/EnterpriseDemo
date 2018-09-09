//
//  Constants.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

enum StoryboardsIds: String {
    case main = "Main"    
}

struct Constants {
    //APIs (Or servers....)
    static let kFinanceApi = "https://www.alphavantage.co/query"
    static let kTheGuardianApi = "https://content.guardianapis.com/search"
    
    //End Points
    struct services {
        static let timeSeriesByMonth = "TIME_SERIES_MONTHLY"
    }
    
    struct ApiKey {
        static let kAlphavantage = "1730BP20UVXJEPF0"
        static let kTheGuardian = "4134ccef-13e1-45df-b406-7423ad88cd12"
    }
    
}
