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
    //MARK: VARIABLES
    var alamofireManager: Alamofire.SessionManager?
    
    //MARK: INIT
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
        }
    }
    
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
