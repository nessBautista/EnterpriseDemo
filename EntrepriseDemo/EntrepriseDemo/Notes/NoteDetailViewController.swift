//
//  NoteDetailViewController.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/7/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import AVFoundation

enum ScreenType:Int {
    case new
    case edit
    case readOnly
}
class NoteDetailViewController: UIViewController {

    //MARK: - VARIABLES AND OUTLETS
    var note = NoteItem()
    var screenType: ScreenType = .readOnly
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblVoiceNote: UILabel!    
    @IBOutlet weak var recorder: Recorder!
    var player: AVAudioPlayer?
    var tracker: CADisplayLink?
    var isPlaying = false
    @IBOutlet weak var lblAudioDuration: UILabel!
    
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var audioSlider: UISlider!
    var onSuccessfullySavedNote:(()->())?
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
    }

    //MARK: - LOADS
    fileprivate func loadConfig() {
        switch self.screenType {
        case .readOnly:
            
            self.txtTitle.text = self.note.title
            self.txtNote.text = self.note.noteDescription
            self.recorder.isHidden = true
            self.lblVoiceNote.isHidden = true
            self.btnSwitch.isHidden = true
            
            self.tracker = CADisplayLink(target: self, selector: #selector(self.updateProgress))
            self.audioSlider.setValue(0.0, animated: false)
            self.lblAudioDuration.isHidden = true
        case .new:
            let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
            self.navigationItem.rightBarButtonItem = saveBtn
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
            self.navigationItem.leftBarButtonItem = cancelBtn
            self.recorder.isHidden = self.btnSwitch.isOn == false
            
            self.setRecorder()
            self.btnPlay.isHidden = true
            self.audioSlider.isHidden = true
        case .edit:
            let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
            self.navigationItem.rightBarButtonItem = saveBtn
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
            self.navigationItem.leftBarButtonItem = cancelBtn
            self.setRecorder()
            
            self.txtTitle.text = self.note.title
            self.txtNote.text = self.note.noteDescription
            self.btnPlay.isHidden = true
            self.audioSlider.isHidden = true
            self.lblAudioDuration.isHidden = true
            
            self.recorder.isHidden = self.btnSwitch.isOn == false
        }
    }
    
    
    //MARK: SAVE-DELETE-CLOSE
    @objc fileprivate func save(){
        print("save")
        guard let title = self.txtTitle.text, title.isEmpty == false else {
            MessageManager.shared.showBar(title: "Add a title", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            return
        }
        
        guard let description = self.txtNote.text, description.isEmpty == false else {
            MessageManager.shared.showBar(title: "Add some info", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            return
        }
        self.note.title = title
        self.note.noteDescription = description
        self.note.creationDate = Date()
        CoreDataBO.sharedInstance.saveNote(self.note){ [weak self] success in
            
            if success == true {
                MessageManager.shared.showBar(title: "Success", subtitle: String(), type: .success, containsIcon: false, fromBottom: false)
                self?.onSuccessfullySavedNote?()
            }
            else {
                MessageManager.shared.showBar(title: "Error", subtitle: String(), type: .error, containsIcon: false, fromBottom: false)
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc fileprivate func cancel(){
        print("cancel")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchDidChange(_ sender: Any) {
        if let btnSwitch = sender as? UISwitch {
            if btnSwitch.isOn == true {
                self.recorder.isHidden = false
                
            } else {
                self.recorder.isHidden = true
            }
        }
    }
    
    
    @IBAction func play(_ sender: Any) {
        let audioFileName = self.note.voiceNote
        guard  audioFileName.isEmpty == false else {
            MessageManager.shared.showBar(title: "This note doesn't have an associated audio", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            return
        }
        let currentFileName = audioFileName
        var documentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let id = "Testing"
        documentsURL = documentsURL.appendingPathComponent("EnterpriseDemo/\(id)/\(currentFileName)")
        print("soundfile \(documentsURL.absoluteString) exists")
        
//        do {
//            self.player = try AVAudioPlayer(contentsOf: documentsURL)
//            self.player?.play()
//        } catch {
//            // couldn't load file :(
//        }
        
        self.player = try? AVAudioPlayer(contentsOf: documentsURL)
        if let audioPlayer = self.player {
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            self.tracker?.preferredFramesPerSecond = 10
            self.tracker?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            self.lblAudioDuration.isHidden = false
            self.lblAudioDuration.text = String().stringFromTimeIntervalMinutes(audioPlayer.duration)
            
            self.isPlaying = true
            
            //Try session to speaker
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            
            audioPlayer.play()
            
            self.updateProgress()
        }
    }
    
    fileprivate func setRecorder(){
    
        self.recorder.onDidEndRecordingSuccessfully = { [weak self] url in
            self?.note.voiceNote = url.lastPathComponent
        }
    }
    
    @objc func updateProgress()
    {
        if let currentTime = self.player?.currentTime, let duration =  self.player?.duration {
            
            self.audioSlider.value = Float(currentTime) / Float(duration)
            print(self.audioSlider.value)
            self.view.setNeedsDisplay()
        }
    }
    
}

extension NoteDetailViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //self.playButton.isSelected = false
        //self.playButton?.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
        self.isPlaying = false
        self.tracker?.isPaused = true
        self.audioSlider.setValue(1.0, animated: true)
//        if let currentTime = self.player?.duration {
//
//            self.lblAudioDuration.text = String().stringFromTimeIntervalMinutes(currentTime)
//        }
    }
}

extension String {
    func stringFromTimeIntervalMinutes(_ interval: TimeInterval) -> String
    {
        let ti = Int(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        //let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
