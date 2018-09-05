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
    
    
    func saveNote(_ note: NoteItem){
        //Get Context
        let context = self.persistentContainer.viewContext
        
        //Get dictionary from note
        let dbNote = Note(context: context)
        dbNote.setValuesForKeys(note.getDictionary())
        
        //Commit save
        do{
            try context.save()
        }catch{
            let nserror = error as NSError
            print("error: \(nserror.userInfo)")
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
                notes.append(noteItem)                
            }
        }
        return notes
    }
}
