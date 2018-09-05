//
//  NotesViewController.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import AVFoundation
class NotesViewController: EnterpriseViewController {

    @IBOutlet weak var recorder: Recorder!
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recorder.onDidEndRecordingSuccessfully = { [weak self] url in
            print(url.absoluteString)
            print(url.relativeString)
            print(url.relativePath)
            
            
        }
        let currentFileName = "recording-2018-09-04-22-48-39.m4a"
        var documentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let id = "Testing"
        documentsURL = documentsURL.appendingPathComponent("EnterpriseDemo/\(id)/\(currentFileName)")
        
        //if FileManager.default.fileExists(atPath: documentsURL.absoluteString)
        //{
            // probably won't happen. want to do something about it?
            print("soundfile \(documentsURL.absoluteString) exists")
            do {
                self.player = try AVAudioPlayer(contentsOf: documentsURL)
                self.player?.play()
            } catch {
                // couldn't load file :(
            }
        //}
        
//        let note = NoteItem()
//        note.title = "This is the note title"
//        note.noteDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//
//        CoreDataBO.sharedInstance.saveNote(note)
//
        self.printStoreLocation()

        CoreDataBO.sharedInstance.getNotes().forEach({print($0.title)})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
