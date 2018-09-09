//
//  ImageExtensions.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

extension UIImageView : URLSessionDelegate{
    
    func setImageWithNoCache(urlString:String, placeholder:UIImage, onSuccess:((_ image:UIImage)->())?)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: urlString)
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            let session: URLSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            if let urlForRequest = url {
                
                let dataTask:URLSessionDataTask = session.dataTask(with: urlForRequest) {
                    data, response, error in
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data:data) {
                            self.image = image
                            self.setNeedsDisplay()
                            onSuccess?(image)
                            
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
}

extension String {
    func toDate() -> Date?
    {
        let dateFormateForDate = DateFormatter()
        dateFormateForDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormateForDate.locale = Locale(identifier: "en_US")
        dateFormateForDate.timeZone = (TimeZone(identifier: "UTC"))
        let dateStringWithoutT = self.replacingOccurrences(of: "T", with: " ")
        
        if dateStringWithoutT.count > 19
        {
            let cut = (dateStringWithoutT as NSString).substring(to: 19)
            return dateFormateForDate.date(from: cut)
        }
        
        return dateFormateForDate.date(from: dateStringWithoutT)
    }
}

extension Date {
    ///Returns Date Format as String June 9, 2015
    func getDateWithMonthName() -> String
    {
        let dateFormateForDate = DateFormatter()
        dateFormateForDate.dateFormat = "MMM d, YYYY"
        dateFormateForDate.locale = Locale(identifier: "en")
        dateFormateForDate.timeZone = .current
        
        return dateFormateForDate.string(from: self)
    }
    
    ///Returns Date Format 12/28/2017
    func getDateSimple() -> String
    {
        let language = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: language)
        
        return dateFormatter.string(from: self)
    }
    
    ///Returns Date Format as String Dec 23, 208 12:28 AM/PM
    func getDateAndTime() -> String
    {
        let dateFormateForDate = DateFormatter()
        dateFormateForDate.dateFormat = "MMMM d, YYYY hh:mm a"
        dateFormateForDate.locale = Locale(identifier: "en")
        dateFormateForDate.timeZone = .current
        
        return dateFormateForDate.string(from: self)
    }
}

extension UIRefreshControl
{
    func setLastUpdate(_ color: UIColor = .darkText)
    {
        self.tintColor = color
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM d, h:mm a"
        let title = "Last update" + ": \(dateFormat.string(from: Date()))"
        let attrs = [NSAttributedStringKey.foregroundColor : color]
        
        attributedTitle = NSAttributedString(string: title, attributes: attrs)
    }
}

