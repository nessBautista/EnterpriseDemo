//
//  Recorder.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/4/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class Recorder: UIView
{
    var id: String = "Testing"//String()
    
    //In case of successful recording
    var onDidEndRecordingSuccessfully: ((_ fileURL: URL)->())?
    var onDidEndRecordingSuccessfullyAlert: ((_ recordAlert: UIAlertController)->())?
    
    //In case of error after recording
    var onRecordingError: ((_ recordAlert: UIAlertController)->())?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib()
    {
        self.addGestureRecognizer(ActionsLongGestureRecognizer(onTap: { state in
            
            if state == .began
            {
                if AVAudioSession.sharedInstance().recordPermission() == .granted
                {
                    //Vibration
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    
                    self.animationStartRecording()
                    AudioManager.shared.id = self.id
                    AudioManager.shared.setUpAudioSessionAndStartRecording()
                }
                else
                {
                    AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                        
                        if granted == true
                        {
                            print("permission granted")
                        }
                        else
                        {
                            print("permission not granted")
                            let alert = UIAlertController(title:"Microphone access", message: "Please active permissions at settings", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler:nil))
                            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (UIAlertAction) in
                                
                                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                    
                                    return
                                }
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        print("Settings opened: \(success)") // Prints true
                                    })
                                }
                                
                            }))
                            
                            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        
                    })
                }
                
            }
            else if state == .ended
            {
                if AVAudioSession.sharedInstance().recordPermission() == .granted
                {
                    self.animationStopRecording()
                    AudioManager.shared.stopRecording()
                    AudioManager.shared.onDidEndRecordingSuccessfully = { [weak self] url in
                        
                        self?.onDidEndRecordingSuccessfully?(url)
                    }
                    AudioManager.shared.onDidEndRecordingSuccessfullyAlert = { [weak self] alert in
                        
                        self?.onDidEndRecordingSuccessfullyAlert?(alert)
                    }
                    AudioManager.shared.onRecordingError = { [weak self] errorAlert in
                        
                        self?.onRecordingError?(errorAlert)
                    }
                    
                }
                
            }
        }))
    }
    
    //MARK:- Animations
    fileprivate func animationStartRecording()
    {
        UIView.animate(withDuration: 0.4, delay:0, options: [.repeat, .autoreverse], animations: {
            
            self.backgroundColor = UIColor.red
            
        }, completion: nil)
    }
    
    fileprivate func animationStopRecording()
    {
        UIView.animate(withDuration: 0.1, delay:0, options: [.curveLinear, .curveEaseOut], animations: {
            
            self.backgroundColor = UIColor(red:0.0, green:0.48, blue:1.0, alpha:1.0)
            
        }, completion: nil)
        UIView.commitAnimations()
    }
}
