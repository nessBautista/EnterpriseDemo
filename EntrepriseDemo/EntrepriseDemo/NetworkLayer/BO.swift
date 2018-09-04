//
//  BO.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BO: NSObject {
    //MARK: - VARIABLES
    var alamofireManager: Alamofire.SessionManager?
    
    
    //MARK: - MAIN GATEWAY
    override init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        configuration.waitsForConnectivity = false
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: nil)
    }
    
    func requestService(service: String, methodType: Alamofire.HTTPMethod, parameters: Any?, isRefresh: Bool = false, onSuccess: @escaping (_ jsonData: JSON)->(), onError: @escaping (NSError) -> ())
    {
        let urlStr = "https://www.alphavantage.co/query"
        guard let url = URL(string: urlStr) else {
            return
        }
        
        
        //Encode Parameters
        let parametersEncodedAndDictionary = self.encodeParameters(methodType: methodType, parameters: parameters)
        let parameterEncoding: ParameterEncoding? = parametersEncodedAndDictionary.0
        let parametersDict: [String: Any]? = parametersEncodedAndDictionary.1
        
        let request = Alamofire.request(url, method: methodType, parameters: parametersDict, encoding: parameterEncoding!, headers: nil)
        request.responseJSON { (data) in
            print(data)
            let responseCode = data.response?.statusCode
            guard data.response != nil && responseCode == 200 else {
                return
            }
            guard let dictResponse = data.result.value else {
                return
            }
            onSuccess(JSON(dictResponse))
        }
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
    
    func getNewsFeed(onSuccess: @escaping(_ timeSeries: TimeSeries)->(), onError: @escaping(NSError)->()){
        var params:[String:Any] = [:]
        params["api-key"] = Constants.ApiKey.kTheGuardian
        //params["show-fields"] = "thumbnail"
        
        self.requestService(service: Constants.kTheGuardianApi, methodType: .get, parameters: params, onSuccess:{[weak self] json in
            
            
            //onSuccess(timeSeries)
            } , onError: onError)
    }
    
    
    //MARK: - UTILITIES
    
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
    
//    private func printServiceRequestLog(url:URL?, service:String, methodType: Alamofire.HTTPMethod, parameters:Any?)
//    {
//        print("\n* * * * * * * * * * * * * * * * * ")
//        if let strUrl = url {
//            
//            print("URL: \(strUrl)")
//        }
//        print("requestingService: \(service) (\(methodType))")
//        print("parameters: \(parameters)\n\n")
//        print("HEADERS: \(BO.RequestHeaders)")
//        print("* * * * * * * * * * * * * * * * * \n")
//    }
}
