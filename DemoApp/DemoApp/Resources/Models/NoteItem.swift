//
//  NoteItem.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/4/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class NoteItem {
    var title: String
    var noteDescription: String
    var creationDate = Date()
    var voiceNote = String()
    init(){
        self.title = String()
        self.noteDescription = String()
    }
    
    func getDictionary()-> [String:Any] {
        var dict:[String:Any] = [:]
        dict["title"] = self.title
        dict["noteDescription"] = self.noteDescription
        dict["creationDate"] = self.creationDate
        dict["voiceNote"] = self.voiceNote
        return dict
    }
}
