//
//  NotesViewController.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/8/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit

class NotesViewController: DemoAppViewController {

    //MARK:- VARIABLES AND OUTLETS
    @IBOutlet weak var tvNoteList: UITableView!
    var vcNoteDetail: NoteDetailViewController?
    var notes:[NoteItem] = [] {
        didSet{
            self.tvNoteList.reloadData()
        }
    }
    
    //MARK:- CLOSURES
    var onEditAction:((_ action: UITableViewRowAction, _ indexPath: IndexPath)->())?
    var onDeleteAction:((_ action: UITableViewRowAction, _ indexPath: IndexPath)->())?
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfig()
        self.getNotes()
    }
    
    //MARK:- LOADS
    fileprivate func loadConfig(){
        self.title = "Note list"
        self.tvNoteList.dataSource = self
        self.tvNoteList.delegate = self 
        //@setNavigationItems
        self.setNavigationItems()
        //@loadNoteListClosures
        self.loadNoteListClosures()
    }
    
    //MARK: @setNavigationItems
    fileprivate func setNavigationItems(){
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    @objc fileprivate func add(){
        let vcNoteDetail: NoteDetailViewController =  Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
        vcNoteDetail.screenType = .new
        vcNoteDetail.onSuccessfullySavedNote = {[weak self] in self?.getNotes()}        
        let navController = DemoAppNavigationViewController(rootViewController: vcNoteDetail)
        self.present(navController, animated: true, completion: nil)
    }
    
    //MARK: @loadNoteListClosures: Manage the delete and edit actions
    fileprivate func loadNoteListClosures() {
        self.onEditAction = {[weak self] (action, indexPath) in
            guard let strongSelf =  self else {return}
            let note = strongSelf.notes[indexPath.row]
            let vcNoteDetail: NoteDetailViewController =  Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
            vcNoteDetail.note = note
            vcNoteDetail.screenType = .edit
            let navController = DemoAppNavigationViewController(rootViewController: vcNoteDetail)
            strongSelf.present(navController, animated: true, completion: nil)
        }
        
        self.onDeleteAction = {[weak self] (action, indexPath) in
            guard let strongSelf =  self else {return}
            let note = strongSelf.notes[indexPath.row]
            CoreDataManager.sharedInstance.deleteNote(note){ success in
                if success == true {
                    self?.getNotes()
                }else {
                    MessageManager.shared.showBar(title: "Error", subtitle: String(), type: .error, containsIcon: false, fromBottom: false)
                }
            }
        }
        
    }
    
    //MARK:- GET NOTES
    //MARK: @getNotes
    fileprivate func getNotes(){
        MessageManager.shared.showLoadingHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            MessageManager.shared.hideHUD()
            self.notes =  CoreDataManager.sharedInstance.getNotes()
        }
    }
}

//MARK:- TABLE DATASOURCE AND DELEGATES
extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.notes[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = note.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.notes[indexPath.row]
        let vcNoteDetail: NoteDetailViewController = Storyboard.getInstanceFromStoryboard(StoryboardsIds.main.rawValue)
        vcNoteDetail.screenType = .readOnly
        vcNoteDetail.note = note
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
