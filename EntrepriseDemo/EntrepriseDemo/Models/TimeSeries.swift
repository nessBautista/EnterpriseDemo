//
//  TimeSeries.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/2/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeSeries
{
    let timeSeries:[[String:TimeSeriesItem]]
    init() {
        self.timeSeries = []
    }
    
    init(json: JSON){
    
        if let dict = json.dictionaryObject {
            var tms:[[String:TimeSeriesItem]] = []
            dict.forEach { (key, value) in
                let jsonItem = JSON(value)
                let dict = [key: TimeSeriesItem(json:jsonItem)]
                tms.append(dict)
            }
            self.timeSeries = tms
        } else{
            self.timeSeries = []
        }
    }
}

class TimeSeriesItem {
    let open: Float
    let high: Float
    let low: Float
    let close: Float
    let volumen: Float
    
    init() {
        self.open = 0
        self.high = 0
        self.low = 0
        self.close = 0
        self.volumen = 0
    }
    init(json:JSON){
        self.open = Float(json["1. open"].string ?? String()) ?? 0
        self.high = Float(json["2. high"].string ?? String()) ?? 0
        self.low = Float(json["3. low"].string ?? String()) ?? 0
        self.close = Float(json["4. close"].string ?? String()) ?? 0
        self.volumen = Float(json["5. volume"].string ?? String()) ?? 0
    }
}
