//
//  CoreDataBO.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/4/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import CoreData

class CoreDataBO {
    
    static let sharedInstance = CoreDataBO()
    
    //MARK: - default Core Data methods
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EnterpriseDemo")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores{ descriptions, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    
    func saveNote(_ note: NoteItem, completionHandler:((_ success:Bool)-> Void)){
        //Get Context
        let mainContext = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate = NSPredicate(format: "title = %@", "\(note.title)")
        request.returnsObjectsAsFaults = false
        
        //Try to find note
        do {
            let result = try mainContext.fetch(request)
            if let noteDB = (result as? [NSManagedObject])?.first {
                let noteTitle = noteDB.value(forKey: "title") as! String
                print("Fetched Note item with title: \(noteTitle)")
                noteDB.setValuesForKeys(note.getDictionary())
            } else {
                //Get dictionary from note
                let dbNote = Note(context: mainContext)
                dbNote.setValuesForKeys(note.getDictionary())
            }
        } catch {
            print("Failed")
            completionHandler(false)
        }
        
        //Commit save
        self.commitChanges { (success) in
            if success == true {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    func getNotes() -> [NoteItem] {
        let mainContext = self.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
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
    
    func deleteNote(_ note: NoteItem, completionHandler:((_ success:Bool)-> Void)){
        let mainContext = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate = NSPredicate(format: "title = %@", "\(note.title)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try mainContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let noteTitle = data.value(forKey: "title") as! String
                print("Fetched Note item")
                mainContext.delete(data)
            }
        } catch {
            print("Failed")
            
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
    
    fileprivate func commitChanges(completionHandler:((_ success:Bool)->Void)) {
        let mainContext = self.persistentContainer.viewContext
        do
        {
            try mainContext.save()
        } catch
        {
            let nserror = error as NSError
            completionHandler(false)
            fatalError("Couldn't save data. Error: \(nserror), \(nserror.userInfo)")
            
        }
        completionHandler(true)
    }
}
