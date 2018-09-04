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
    var data:[(String, TimeSeriesItem)]
    init() {
        self.data = [(String(), TimeSeriesItem())]
    }
    
    init(json: JSON){
    
        if let dict = json.dictionaryObject {
            var tms:[(String,TimeSeriesItem)] = []
            dict.forEach { (key, value) in
                
                let jsonItem = JSON(value)
                tms.append((key, TimeSeriesItem(json:jsonItem)))
            }
            self.data = tms
        } else{
            self.data = [(String(), TimeSeriesItem())]
        }
    }
}

class TimeSeriesItem {
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volumen: Double
    
    init() {
        self.open = 0
        self.high = 0
        self.low = 0
        self.close = 0
        self.volumen = 0
    }
    init(json:JSON){
        self.open = Double(json["1. open"].string ?? String()) ?? 0
        self.high = Double(json["2. high"].string ?? String()) ?? 0
        self.low = Double(json["3. low"].string ?? String()) ?? 0
        self.close = Double(json["4. close"].string ?? String()) ?? 0
        self.volumen = Double(json["5. volume"].string ?? String()) ?? 0
    }
}
