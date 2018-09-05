//
//  AudioManager.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/4/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import AVFoundation


private let sharedInstanceManager = AudioManager()

class AudioManager: NSObject
{
    //Shared instance
    class var shared: AudioManager
    {
        return sharedInstanceManager
    }
    
    //Closures
    //In case of successful recording
    var onDidEndRecordingSuccessfullyAlert: ((_ recordAlert: UIAlertController)->())?
    var onDidEndRecordingSuccessfully: ((_ fileURL: URL)->())?
    
    //In case of error after recording
    var onRecordingError: ((_ recordAlert: UIAlertController)->())?
    
    
    //Audio elements
    var audioSession: AVAudioSession?
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var recordedFile: URL?
    var id: String = String()
    
    override init()
    {
        self.audioSession = AVAudioSession.sharedInstance()
        super.init()
    }
    
    func setUpAudioSessionAndStartRecording()
    {
        guard let session = self.audioSession else {
            
            print("Couldn't obtain audiosession")
            return
        }
        if self.recorder == nil || self.recorder?.isRecording == false
        {
            self.setSessionPlayback(session)
            self.askForNotifications()
            self.checkHeadphones()
            self.recordWithPermission(true)
        }
    }
    
    func stopRecording()
    {
        self.recorder?.stop()
        if let session = self.audioSession {
            do {
                try session.setActive(false)
            } catch let error as NSError {
                print("could not make session inactive")
                print(error.localizedDescription)
            }
        }
    }
    
    func recordWithPermission(_ setup: Bool)
    {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) == true)
        {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted == true
                {
                    print("Permission to record granted")
                    guard let session = self.audioSession else {
                        
                        print("Audio session instance in Audio Session Manager is empty")
                        return
                    }
                    self.setSessionPlayAndRecord(session)
                    
                    if setup == true
                    {
                        self.setupRecorder()
                    }
                    self.recorder?.record()
                }
                else
                {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    //MARK: Audio Sessions Setup
    fileprivate func setSessionPlayback(_ session: AVAudioSession)
    {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord(_ session: AVAudioSession)
    {
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    //MARK: Notifications
    fileprivate func askForNotifications()
    {
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.background(_:)),
                                               name:NSNotification.Name.UIApplicationWillResignActive,
                                               object:nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.foreground(_:)),
                                               name:NSNotification.Name.UIApplicationWillEnterForeground,
                                               object:nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.routeChange(_:)),
                                               name:NSNotification.Name.AVAudioSessionRouteChange,
                                               object:nil)
    }
    
    @objc func background(_ notification:Notification) {
        print("background")
    }
    
    @objc func foreground(_ notification:Notification) {
        print("foreground")
    }
    
    @objc func routeChange(_ notification:Notification)
    {
        print("routeChange \((notification as NSNotification).userInfo)")
        
        if let userInfo = (notification as NSNotification).userInfo {
            //print("userInfo \(userInfo)")
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    //MARK: Check for headphones
    private func checkHeadphones()
    {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        if let currentRoute = self.audioSession?.currentRoute {
            
            if currentRoute.outputs.count > 0
            {
                for description in currentRoute.outputs
                {
                    if description.portType == AVAudioSessionPortHeadphones
                    {
                        print("headphones are plugged in")
                        break
                    }
                    else
                    {
                        print("headphones are unplugged")
                    }
                }
            }
            else
            {
                print("checking headphones requires a connection to a device")
            }
        }
    }
    
    func setupRecorder()
    {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        print(currentFileName)
        
        if self.doesDirectoryExist() == false
        {
            var audioPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioPath = self.id.isEmpty == false ? audioPath.appendingPathComponent("EnterpriseDemo/\(self.id)") : audioPath.appendingPathComponent("General/Audios")
            
            do
            {
                try FileManager.default.createDirectory(atPath: audioPath.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError
            {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        
        var documentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        documentsURL = self.id.isEmpty == false ? documentsURL.appendingPathComponent("EnterpriseDemo/\(self.id)/\(currentFileName)") : documentsURL.appendingPathComponent("General/Audios/\(currentFileName)")
        
        if FileManager.default.fileExists(atPath: documentsURL.absoluteString)
        {
            // probably won't happen. want to do something about it?
            print("soundfile \(documentsURL.absoluteString) exists")
        }
        
        self.recordedFile = documentsURL
        
        let recordSettings:[String : Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do
        {
            self.recorder = try AVAudioRecorder(url: documentsURL, settings: recordSettings)
            self.recorder?.delegate = self
            self.recorder?.isMeteringEnabled = true
            self.recorder?.prepareToRecord() // creates/overwrites the file at soundFileURL
        }
        catch let error as NSError
        {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    func doesDirectoryExist() -> Bool
    {
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        path = self.id.isEmpty == false ? path.appendingPathComponent("EnterpriseDemo/\(self.id)") : path.appendingPathComponent("General/Audios")
        
        if let doesResourceExists = try? path.checkResourceIsReachable(), doesResourceExists == true {
            
            return true
        }
        
        return false
        
    }
}



extension AudioManager: AVAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool)
    {
        print("finished recording \(flag)")
        if flag == true
        {
            // Send out recorded file URL
            if let doesResourceExists = try? self.recordedFile?.checkResourceIsReachable(), doesResourceExists == true {
                
                self.onDidEndRecordingSuccessfully?(self.recordedFile!)
            }
            //Send out alert with the option of delete recorded audio
            self.onDidEndRecordingSuccessfullyAlert?(self.createAlertWithDeleteOption())
        }
        else
        {
            //Send out error alert
            self.onRecordingError?(self.createRecordingErrorAlert())
        }
    }
    
    //MARK: AUDIO ALERTS
    func createAlertWithDeleteOption() -> UIAlertController
    {
        // iOS8 and later
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: {action in
            print("keep was tapped")
            
            if let doesResourceExists = try? self.recordedFile?.checkResourceIsReachable(), doesResourceExists == true {
                
                self.onDidEndRecordingSuccessfully?(self.recordedFile!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
            print("delete was tapped")
            
            self.recorder?.deleteRecording()
        }))
        
        return alert
    }
    
    func createRecordingErrorAlert() -> UIAlertController
    {
        // iOS8 and later
        let alert = UIAlertController(title: "Recording Error",
                                      message: "Couldn't record audio",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        
        return alert
    }
    
    func loadAlertForMicrophonePermissionsDenied() -> UIAlertController
    {
        let alert = UIAlertController(title: "You don't have microphone access",
                                      message: "Open settings to change permissions",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
    
}

