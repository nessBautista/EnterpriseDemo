//
//  UserDefaultManager.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

enum Defaults: String
{
    case kUserName
    case kPassword
    case kTheGuardian
    case kFinance
    case kLogedIn
}

class UserDefaultManager: NSObject {

    class func saveUserDefaults(dict: [String: String]) {
        UserDefaults.standard.set(dict[Defaults.kUserName.rawValue], forKey: Defaults.kUserName.rawValue)
        UserDefaults.standard.set(dict[Defaults.kPassword.rawValue], forKey: Defaults.kPassword.rawValue)
        UserDefaults.standard.set(dict[Defaults.kTheGuardian.rawValue], forKey: Defaults.kTheGuardian.rawValue)
        UserDefaults.standard.set(dict[Defaults.kFinance.rawValue], forKey: Defaults.kFinance.rawValue)
        
        UserDefaults.standard.synchronize()
    }
    
    class func getUserDefaults() -> [String:String] {
        var userDefaults : [String: String] = [:]
        userDefaults [Defaults.kUserName.rawValue] = UserDefaults.standard.string(forKey: Defaults.kUserName.rawValue)
        userDefaults [Defaults.kPassword.rawValue] = UserDefaults.standard.string(forKey: Defaults.kPassword.rawValue)
        userDefaults [Defaults.kTheGuardian.rawValue] = UserDefaults.standard.string(forKey: Defaults.kTheGuardian.rawValue)
        userDefaults [Defaults.kFinance.rawValue] = UserDefaults.standard.string(forKey: Defaults.kFinance.rawValue)
        
        return userDefaults
    }
    
    class func setLogInStatus(status: Bool){
        UserDefaults.standard.set(status, forKey: Defaults.kLogedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    class func getLoginStatus()-> Bool {
        let status = UserDefaults.standard.bool(forKey: Defaults.kLogedIn.rawValue)
        return status
    }
    class func cleanUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Defaults.kUserName.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.kPassword.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.kTheGuardian.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.kFinance.rawValue)
        
        UserDefaults.standard.synchronize()
    }
}
