//
//  NoteDetailViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/9/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit
import AVFoundation
class NoteDetailViewController: UIViewController {

    //MARK: - VARIABLES AND OUTLETS
    var note = NoteItem()
    var screenType: ScreenType = .readOnly
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var lblVoiceNote: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var recorder: Recorder!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var lblDuration: UILabel!
    
    var player: AVAudioPlayer?
    var tracker: CADisplayLink?
    var isPlaying = false
    
    //MARK: - CLOSURES
    var onSuccessfullySavedNote:(()->())?
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
    }
    
    //MARK: - LOADS
    fileprivate func loadConfig() {
        switch self.screenType {
        case .new:
            self.setUIForNewNote()
        case .edit:
            self.setUIForEdition()
        case .readOnly:
            self.setUIForReadOnly()
        }
    }
    
    //MARK: @setUIForReadOnly
    fileprivate func setUIForReadOnly() {
        self.title = "Note Detail"
        self.txtTitle.text = self.note.title
        self.txtNote.text = self.note.noteDescription
        self.recorder.isHidden = true
        self.lblVoiceNote.isHidden = true
        self.btnSwitch.isHidden = true
        
        self.tracker = CADisplayLink(target: self, selector: #selector(self.updateProgress))
        self.audioSlider.setValue(0.0, animated: false)
        self.lblDuration.isHidden = true
    }
    
    //MARK: @setUIForNewNote
    fileprivate func setUIForNewNote(){
        self.title = "New Note"
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveNoteDetail))
        self.navigationItem.rightBarButtonItem = saveBtn
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.leaveNoteDetail))
        self.navigationItem.leftBarButtonItem = cancelBtn
        self.recorder.isHidden = self.btnSwitch.isOn == false
        
        self.setRecorder()
        self.btnPlay.isHidden = true
        self.audioSlider.isHidden = true
        self.lblDuration.isHidden = true
    }
    
    //MARK: @setUIForEdition
    fileprivate func setUIForEdition(){
        self.title = "Edit Note"
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveNoteDetail))
        self.navigationItem.rightBarButtonItem = saveBtn
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.leaveNoteDetail))
        self.navigationItem.leftBarButtonItem = cancelBtn
        self.setRecorder()
        
        self.txtTitle.text = self.note.title
        self.txtNote.text = self.note.noteDescription
        self.btnPlay.isHidden = true
        self.audioSlider.isHidden = true
        self.lblDuration.isHidden = true
        
        self.recorder.isHidden = self.btnSwitch.isOn == false
    }
    
    //MARK: - PLAY AUDIO
    @IBAction func playVoiceNote(_ sender: Any) {
        //-------Get file name from Note item instance
        let audioFileName = self.note.voiceNote
        guard  audioFileName.isEmpty == false else {
            MessageManager.shared.showBar(title: "This note doesn't have an associated audio", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            return
        }
        let currentFileName = audioFileName
        
        //-------Get URL for voice note
        var documentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let id = "Testing"
        documentsURL = documentsURL.appendingPathComponent("DemoAppStorage/\(id)/\(currentFileName)")
        print("soundfile \(documentsURL.absoluteString) exists")
        
        //-------Play audio with AVFoundation instances
        self.player = try? AVAudioPlayer(contentsOf: documentsURL)
        if let audioPlayer = self.player {
            
            //AudioPlayer Configuration
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            self.tracker?.preferredFramesPerSecond = 10
            self.tracker?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            self.tracker?.isPaused = false
            self.lblDuration.isHidden = false
            self.lblDuration.text = String().stringFromTimeIntervalMinutes(audioPlayer.duration)
            self.isPlaying = true
            
            //Start audio session
            let session = AVAudioSession.sharedInstance()
            do{
               try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            }catch{
                MessageManager.shared.showBar(title: "Error initializing Audio Session", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            }
            
            //Play and start slider animation
            audioPlayer.play()
            self.updateProgress()
        }
    }
    
    //MARK: - SAVE / DELETE / CANCEL
    //MARK: @saveNoteDetail
    @objc fileprivate func saveNoteDetail(){
        //---- Safaty guards
        guard let title = self.txtTitle.text, title.isEmpty == false else {
            MessageManager.shared.showBar(title: "Add a title", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            return
        }
        guard let description = self.txtNote.text, description.isEmpty == false else {
            MessageManager.shared.showBar(title: "Add some info", subtitle: String(), type: .warning, containsIcon: false, fromBottom: false)
            return
        }
        
        //---- Update Note Item Instance with UI input
        self.note.title = title
        self.note.noteDescription = description
        self.note.creationDate = Date()
        
        //--- Save to core data
        CoreDataManager.sharedInstance.saveNote(self.note){ [weak self] success in
            
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
    //MARK: @deleteNoteDetail
    @objc fileprivate func deleteNoteDetail(){
        
    }
    //MARK: @leaveNoteDetail
    @objc fileprivate func leaveNoteDetail(){
        print("leave")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: @onSwitchStateChanged
    @IBAction func onSwitchStateChanged(_ sender: Any) {
        if let ctrlSwitch = sender as? UISwitch {
            self.recorder.isHidden = ctrlSwitch.isOn == false
        }
    }
    
    
    //MARK: - UTILITIES
    @objc func updateProgress()
    {
        if let currentTime = self.player?.currentTime, let duration =  self.player?.duration {
            
            self.audioSlider.value = Float(currentTime) / Float(duration)
            print(self.audioSlider.value)
            self.view.setNeedsDisplay()
        }
    }
    fileprivate func setRecorder(){
        self.recorder.onDidEndRecordingSuccessfully = { [weak self] url in
            self?.note.voiceNote = url.lastPathComponent
        }
    }
}

extension NoteDetailViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        self.isPlaying = false
        self.tracker?.isPaused = true
        self.audioSlider.setValue(0.0, animated: true)        
    }
}

