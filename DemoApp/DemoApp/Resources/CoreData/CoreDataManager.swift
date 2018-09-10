//
//  CoreDataManager.swift
//  DemoApp
//
//  Created by Nestor Hernandez on 9/9/18.
//  Copyright © 2018 Nestor Hernandez. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    //MARK: - GET PERSISTENT CONTAINER
    //MARK: @persistentContainer: Function should get an instance of the CoreData model
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores{ descriptions, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK: @commitChanges
    fileprivate func commitChanges(completionHandler:((_ success:Bool)->Void)) {
        let mainContext = self.persistentContainer.viewContext
        do
        {
            try mainContext.save()
        }
        catch
        {
            let nserror = error as NSError
            completionHandler(false)
            fatalError("Couldn't save data. Error: \(nserror), \(nserror.userInfo)")
        }
        completionHandler(true)
    }
    
    //MARK: @getNotes
    func getNotes() -> [NoteItem] {
        
        //Get context
        let mainContext = self.persistentContainer.viewContext
        
        //Create a fetch request for ALL items of type Note
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        
        //Transform all result objects to our NoteItem Model
        var notes:[NoteItem] = []
        
        if let fetchResponse = try? mainContext.fetch(fetchRequest){
            
            fetchResponse.forEach { (note) in
                let noteItem = NoteItem()
                noteItem.title = note.title ?? String()
                noteItem.noteDescription = note.noteDescription ?? String()
                noteItem.creationDate = note.creationDate ?? Date()
                noteItem.voiceNote = note.voiceNote ?? String()
                notes.append(noteItem)
            }
        }
        
        return notes
    }
    
    
    //MARK: @saveNote: Should save changes to an existing Note object or create a new one
    func saveNote(_ note: NoteItem, completionHandler:((_ success:Bool)-> Void)){
        
        //Get Context
        let mainContext = self.persistentContainer.viewContext
        
        //Contruct a fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate = NSPredicate(format: "title = %@", "\(note.title)")
        request.returnsObjectsAsFaults = false
        
        
        do {
            //Execute request
            let result = try mainContext.fetch(request)
            
            //If an object found, set changes
            if let noteDB = (result as? [NSManagedObject])?.first {
                let noteTitle = noteDB.value(forKey: "title") as! String
                print("Fetched Note item with title: \(noteTitle)")
                noteDB.setValuesForKeys(note.getDictionary())
            }
            else
            {
            
                //If new object, create a new instance in the core data model
                let dbNote = Note(context: mainContext)
                dbNote.setValuesForKeys(note.getDictionary())
            }
        } catch {
            print("Failed")
            completionHandler(false)
        }
        
        //Commit changes
        self.commitChanges { (success) in
            if success == true {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    //MARK: @deleteNote: Should save changes to an existing Note object or create a new one
    func deleteNote(_ note: NoteItem, completionHandler:((_ success:Bool)-> Void)){
        //Get context
        let mainContext = self.persistentContainer.viewContext
        
        //Contruct a fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate = NSPredicate(format: "title = %@", "\(note.title)")
        request.returnsObjectsAsFaults = false
        
        
        do {
            //Execute request
            let result = try mainContext.fetch(request)
            //Delete all result objects
            for data in result as! [NSManagedObject] {
                let noteTitle = data.value(forKey: "title") as! String
                print("Fetched Note item")
                mainContext.delete(data)
            }
        }
        catch
        {
            print("Failed")
            completionHandler(false)
        }
        
        //Commit changes
        self.commitChanges { (success) in
            if success == true {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
}
