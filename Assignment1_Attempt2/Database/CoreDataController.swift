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
    var listeners = MulticastDelegate<DatabaseListener>()
    
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
        if fetchAllPlaces().count == 0 {
        createDefaultEntries()
            
        }
    }

    func saveContext() {
        if persistantContainer.viewContext.hasChanges{
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)") }
        }
    }
    
    func addSight(name: String, desc: String, icon: String, photo: String) -> Place {
        
        let sight = NSEntityDescription.insertNewObject(forEntityName:"Place" , into: persistantContainer.viewContext) as! Place
        sight.name = name;
        sight.desc = desc;
        sight.icon = icon;
        sight.photo = photo;
        saveContext()
        return sight
        
        
    }
    
    func updateSight() -> Bool {
        saveContext()
        return true
    }
    
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        //if listener.listenerType == ListenerType.all || listener.listenerType == ListenerType.sight {
        listener.onSightListChange(change: .update, sights: fetchAllPlaces())
        //}
    }
    
    func fetchAllPlaces() -> [Place] {
        if allSightsFetchedResultController == nil {
            let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allSightsFetchedResultController = NSFetchedResultsController<Place>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allSightsFetchedResultController?.delegate = self
            
            do{
                try allSightsFetchedResultController?.performFetch()
            }catch{
                print("Fetch Request failed: \(error)")
            }
        }
        var places = [Place]()
        if allSightsFetchedResultController?.fetchedObjects != nil{
            places = (allSightsFetchedResultController?.fetchedObjects)!
        }
        return places
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSightsFetchedResultController {
            listeners.invoke{(listener) in
                listener.onSightListChange(change: .update, sights: fetchAllPlaces())
                
            }
        }
        //saveContext()
    }
    
    func createDefaultEntries() {
        let _ = addSight(name: "Flinders", desc: "Flinders Description", icon: "Flinders Icon" ,photo: "luffy")
        let _ = addSight(name: "Parliament", desc: "Something", icon: "more something", photo: "luffy")
        let _ = addSight(name: "WOW", desc: "WTF", icon: "HOW MUCH", photo: "")
        
    }
    
}


