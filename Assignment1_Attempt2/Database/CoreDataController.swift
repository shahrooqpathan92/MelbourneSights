//
//  CoreDataController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 3/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    //let DEFAULT_TEAM_NAME = "Default Team"
    //var listeners = MulticastDelegate<DatabaseListener>()
    
    var persistantContainer: NSPersistentContainer
    
    //Results
    var allSightsFetchedResultController: NSFetchedResultsController<Place>?
    
    override init(){
        persistantContainer = NSPersistentContainer(name: "SightsModel")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
                
            }
        }
        
        super.init()
        // If there are no heroes in the database assume that the app is running // for the first time. Create the default team and initial superheroes.
        //if fetchAllPlaces().count == 0 {
        //  createDefaultEntries() }
    }
    
    
    func saveContext() {
        if persistantContainer.viewContext.hasChanges{
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)") }
        }
    }
    
    func addSight(newSight: Sight) {
        
    }
}


