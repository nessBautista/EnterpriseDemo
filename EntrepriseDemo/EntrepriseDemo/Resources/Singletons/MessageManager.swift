//
//  MessageManager.swift
//  Swift3MessagesDemo
//
//  Created by Nestor Javier Hernandez Bautista on 10/24/16.
//  Copyright © 2016 Nestor Javier Hernandez Bautista. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
import PKHUD
import SwiftySound

private let sharedInstanceManager = MessageManager()

enum MessageType:Int
{
    case success = 0
    case warning
    case error
    case info
}

class MessageManager: NSObject
{
    
    //SHARED INSTANCE
    class var shared: MessageManager
    {
        return sharedInstanceManager
    }
    
    func showSuccessHUD()
    {
        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
        PKHUD.sharedHUD.show()
    }
    
    func showLoadingHUD()
    {
        //Sound.play(file: "sound_request.wav")
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
    }
    
    func showErrorHUD()
    {
        PKHUD.sharedHUD.contentView = PKHUDErrorView()
        PKHUD.sharedHUD.show()
    }
    
    func showSystemHUD()
    {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
    }
    
    func hideHUD()
    {
        PKHUD.sharedHUD.hide()
    }
    
    //MARK: Agile messages
    func showStatusBar(title: String? = nil, type: MessageType = .success, containsIcon: Bool = false)
    {
        let status = MessageView.viewFromNib(layout: .statusLine)
        
        var message = String()
        
        switch type
        {
        case .success:
            status.backgroundView.backgroundColor = MessageManager.successColor()
            status.bodyLabel?.textColor = UIColor.white
            message = title ?? "Success"
            
            //Sound.play(file: "sound_success.wav")
            
        case .warning:
            status.backgroundView.backgroundColor = MessageManager.warningColor()
            status.bodyLabel?.textColor = UIColor.black
            message = title ?? "Warning"
            
            //Sound.play(file: "sound_warning.wav")
            
        case .error:
            status.backgroundView.backgroundColor = MessageManager.errorColor()
            status.bodyLabel?.textColor = UIColor.white
            message = title ?? "Error"
            
            //Sound.play(file: "sound_failure.wav")
            
        case .info:
            status.backgroundView.backgroundColor = MessageManager.infoColor()
            status.bodyLabel?.textColor = UIColor.white
            message = title ?? "Info"
            
            //Sound.play(file: "sound_info.wav")
        }
        
        status.configureContent(body: message)
        
        var statusConfig = SwiftMessages.Config()
        statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar) //.automatic
       
        // Show the message.
        SwiftMessages.show(config: statusConfig,view: status)
    }
    
    func showBar(title: String? = nil, subtitle: String? = String(), type: MessageType = .success, containsIcon: Bool = false, fromBottom: Bool = true)
    {
        let message = MessageView.viewFromNib(layout: .cardView)
        message.configureDropShadow()
        
        var strTitle = String()
        
        switch type
        {
        case .success:
            if containsIcon == true
            {
                message.configureTheme(.success, iconStyle: .subtle)
            }
            
            message.titleLabel?.textColor = .white
            message.backgroundView.backgroundColor = MessageManager.successColor()
            message.bodyLabel?.textColor = UIColor.white
            strTitle = title ?? "Success"
            
            //Sound.play(file: "sound_success.wav")
            
        case .warning:
            if containsIcon == true
            {
                message.configureTheme(.warning, iconStyle: .subtle)
            }
            message.backgroundView.backgroundColor = MessageManager.warningColor()
            message.titleLabel?.textColor = .black
            message.bodyLabel?.textColor = .black
            message.iconImageView?.tintColor = .black
            strTitle = title ?? "Warning"
            
            //Sound.play(file: "sound_warning.wav")
            
        case .error:
            if containsIcon == true
            {
                message.configureTheme(.error, iconStyle: .subtle)
            }
             message.titleLabel?.textColor = .white
            message.backgroundView.backgroundColor = MessageManager.errorColor()
            message.bodyLabel?.textColor = UIColor.white
            strTitle = title ?? "Error"
            
            //Sound.play(file: "sound_failure.wav")
            
        case .info:
            if containsIcon == true
            {
                message.configureTheme(.info, iconStyle: .subtle)
            }
             message.titleLabel?.textColor = .white
            message.backgroundView.backgroundColor = MessageManager.infoColor()
            message.bodyLabel?.textColor = UIColor.white
            strTitle = title ?? "Info"
            
            //Sound.play(file: "sound_info.wav")
        }
        
        message.button?.isHidden = true
        message.iconLabel?.isHidden = true
        message.iconImageView?.isHidden = containsIcon == false ? true : false
        message.configureContent(title: strTitle, body: subtitle ?? String())
       
        var statusConfig = SwiftMessages.Config()
        statusConfig.dimMode = .color(color: .clear, interactive: true)
        statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        statusConfig.presentationStyle = fromBottom == true ? .bottom : .top
        
        // Show the message.
        SwiftMessages.show(config: statusConfig,view: message)
    }
}

//MARK: Colors
extension MessageManager
{
    ///Default color for Errors
    class func errorColor() -> UIColor
    {
        return UIColor(red:0.768627, green: 0.000000, blue: 0.117647, alpha: 1)
    }
    
    ///Default color for Success actions
    class func successColor() -> UIColor
    {
        return UIColor(red:0.117647, green: 0.694118, blue: 0.541176, alpha: 1)
    }
    
    ///Default color for information
    class func infoColor() -> UIColor
    {
        return UIColor(red: 0.054902, green: 0.466667, blue: 0.866667, alpha: 1)
    }
    
    ///Default color for warnings
    class func warningColor() -> UIColor
    {
        return UIColor(red: 1.000000, green: 0.968627, blue: 0.643137, alpha: 1 )
    }
}
