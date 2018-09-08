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

    //@IBOutlet weak var recorder: Recorder!
    //var player: AVAudioPlayer?
    
    //MARK: VARIABLES AND OUTLETS
    var vcNoteDetail: NoteDetailViewController?
    @IBOutlet weak var tvNoteList: UITableView!
    var notes:[NoteItem] = [] {
        didSet{
            self.tvNoteList.reloadData()
        }
    }
    var onEditAction:((_ action: UITableViewRowAction, _ indexPath: IndexPath)->())?
    var onDeleteAction:((_ action: UITableViewRowAction, _ indexPath: IndexPath)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
        self.loadClosures()
        self.getNotes()
//        let note = NoteItem()
//        note.title = "Note 2"
//        note.noteDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//
//        CoreDataBO.sharedInstance.saveNote(note)
//
//
//        self.printStoreLocation()
//        self.notes =  CoreDataBO.sharedInstance.getNotes()
        /*
        self.recorder.onDidEndRecordingSuccessfully = { [weak self] url in
            print(url.absoluteString)
            print(url.relativeString)
            print(url.relativePath)
            
            
        }
        let currentFileName = "recording-2018-09-04-22-48-39.m4a"
        var documentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let id = "Testing"
        documentsURL = documentsURL.appendingPathComponent("EnterpriseDemo/\(id)/\(currentFileName)")
        print("soundfile \(documentsURL.absoluteString) exists")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: documentsURL)
            self.player?.play()
        } catch {
            // couldn't load file :(
        }
        */
        
        
//
        
    }
    
    //MARK: WEB SERVICE - DATA FETCH
    fileprivate func getNotes(){
        MessageManager.shared.showLoadingHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            MessageManager.shared.hideHUD()
            self.notes =  CoreDataBO.sharedInstance.getNotes()
        }        
    }

    //MARK:- loads
    fileprivate func loadConfig() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
        self.navigationItem.rightBarButtonItem = addBtn
    }

    //MARK: -Add-delete
    @objc fileprivate func add(){
        let vcNoteDetail: NoteDetailViewController =  Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
        vcNoteDetail.screenType = .new
        vcNoteDetail.onSuccessfullySavedNote = {[weak self] in self?.getNotes()}
        
        let navController = EnterpriseNavigationController(rootViewController: vcNoteDetail)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func delete(){
        print("delete")
    }
    
    fileprivate func loadClosures(){
     
        self.onEditAction = {[weak self] (action, indexPath) in
            guard let strongSelf =  self else {return}
            let note = strongSelf.notes[indexPath.row]
            let vcNoteDetail: NoteDetailViewController =  Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            vcNoteDetail.note = note
            vcNoteDetail.screenType = .edit
            let navController = EnterpriseNavigationController(rootViewController: vcNoteDetail)
            strongSelf.present(navController, animated: true, completion: nil)
        }
        
        self.onDeleteAction = {[weak self] (action, indexPath) in
            guard let strongSelf =  self else {return}
            let note = strongSelf.notes[indexPath.row]
            CoreDataBO.sharedInstance.deleteNote(note){ success in
                if success == true {
                    self?.getNotes()
                }else {
                    MessageManager.shared.showBar(title: "Error", subtitle: String(), type: .error, containsIcon: false, fromBottom: false)
                }
            }
        }
    }
}

//MARK:- TABLE DATA SOURCE AND DELEGATES

extension NotesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.notes[indexPath.row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = note.title
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.notes[indexPath.row]
        let vcNoteDetail: NoteDetailViewController =  Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
        vcNoteDetail.note = note
        vcNoteDetail.screenType = .readOnly
        self.navigationController?.pushViewController(vcNoteDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: self.onEditAction!)
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: self.onDeleteAction!)
        return [deleteAction,editAction]
    }
}
