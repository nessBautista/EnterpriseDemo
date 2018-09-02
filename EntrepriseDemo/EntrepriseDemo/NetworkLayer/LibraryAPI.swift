//
//  LibraryAPI.swift
//  EntrepriseDemo
//
//  Created by Néstor Hernández Bautista on 9/1/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit

class LibraryAPI {
    //Singleton
    static let shared = LibraryAPI()
    
    lazy var bo = BO()
    
    fileprivate init()
    {
        //This prevents others from using the default '()' initializer for this class.
    }
}
