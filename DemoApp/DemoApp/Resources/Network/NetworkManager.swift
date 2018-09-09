//
//  NetworkManager.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {

    //MARK:- VARIABLES
    var alamofireManager: Alamofire.SessionManager?
    
    //MARK:- MAIN GATEWAY
    override init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        configuration.waitsForConnectivity = false
        alamofireManager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: nil)
    }
    
    //MARK: @requestService
    func requestService(service: String, methodType: Alamofire.HTTPMethod, parameters: Any?, isRefresh: Bool = false, onSuccess: @escaping (_ jsonData: JSON)->(), onError: @escaping (NSError) -> ())
    {
        //1 Construct the request URL with the service name (This is the name of the server + API End point)
        let urlStr = service
        guard let url = URL(string: urlStr) else {
            return
        }
        
        //2 Encode Parameters
        let parametersEncodedAndDictionary = self.encodeParameters(methodType: methodType, parameters: parameters)
        let parameterEncoding: ParameterEncoding? = parametersEncodedAndDictionary.0
        let parametersDict: [String: Any]? = parametersEncodedAndDictionary.1
        
        //3 Play request
        let request = Alamofire.request(url, method: methodType, parameters: parametersDict, encoding: parameterEncoding!, headers: nil)
        request.responseJSON { (data) in
            print(data)
            let responseCode = data.response?.statusCode
            
            //4 ----Basic Response validations and Json extraction
            //200 OK
            guard data.response != nil && responseCode == 200 else {
                return
            }
            //Extract JSON from data
            guard let dictResponse = data.result.value else {
                return
            }
            
            //5 Response with completion handler
            onSuccess(JSON(dictResponse))
        }
    }
    
    //MARK:- UTILITY
    //MARK: @encodeParameters
    private func encodeParameters(methodType: Alamofire.HTTPMethod, parameters: Any?) -> (ParameterEncoding? , [String: Any]?)
    {
        var parameterEncoding: ParameterEncoding? = nil
        var parametersDict: [String: Any]? = nil
        
        //Check if the parameters are made of a dictionary
        if let existingParameters = parameters as? [String : Any] {
            
            parameterEncoding = methodType == Alamofire.HTTPMethod.get ? URLEncoding.default : JSONEncoding.default
            parametersDict = existingParameters
        }
            //Check if the parameters are made of a String
        else if let _ /*plainText*/ = parameters as? String {
            
            parameterEncoding = URLEncoding.httpBody
            parametersDict = [:]
        }
        else
        {
            //If the parameter is not a dictionary or string encode a Json default
            print("*** Parameters is not a Dictionary or String ***")
            parametersDict = nil
            parameterEncoding = JSONEncoding.default
        }
        
        return (parameterEncoding, parametersDict)
    }
}

//MARK:- API CALLS
extension NetworkManager {
    //MARK: - NEWS DATA
    func getNewsFeed(_ params:[String:Any], onSuccess: @escaping((news: [NewsItem], pagination: Pagination))->(), onError: @escaping(NSError)->()){
        
        self.requestService(service: Constants.kTheGuardianApi, methodType: .get, parameters: params, onSuccess:{[weak self] json in
            let pagination = Pagination(json: json["response"])
            var newsItems:[NewsItem] = []
            if let items = json["response"]["results"].array {
                newsItems = items.map({NewsItem(json:$0)})
            }
            onSuccess((newsItems, pagination))            
            } , onError: onError)
    }
    
    //MARK: - FINANCE DATA
    func getTimeSeriesFor(equity:String, onSuccess: @escaping(_ timeSeries: TimeSeries)->(), onError: @escaping(NSError)->()){
        var params:[String:Any] = [:]
        params["function"] = Constants.services.timeSeriesByMonth
        params["apikey"] = Constants.ApiKey.kAlphavantage
        params["symbol"] = equity
        self.requestService(service: Constants.kFinanceApi, methodType: .get, parameters: params, onSuccess:{[weak self] json in
            
            let timeSeries = TimeSeries(json: json["Monthly Time Series"])
            onSuccess(timeSeries)
            } , onError: onError)
    }
}
