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
    
    func addSight(name: String, desc: String, icon: String, photo: String, lat: Double, long: Double) -> Place {
        
        let sight = NSEntityDescription.insertNewObject(forEntityName:"Place" , into: persistantContainer.viewContext) as! Place
        sight.name = name;
        sight.desc = desc;
        sight.icon = icon;
        sight.photo = photo;
        sight.lat = lat;
        sight.long = long;
        saveContext()
        return sight
        
        
    }
    
    func updateSight() -> Bool {
        saveContext()
        return true
    }
    
    //Getting a single sight name
    func getSight(name: String) -> Place? {
        
        var allSights:[Place] = fetchAllPlaces()
        
        for place in allSights {
            if place.name == name
            {
                return place
            }
        }
        //will never return
        return nil
    }
    
    //Deleting an entiy
    func deleteSight(sight: Place) {
        persistantContainer.viewContext.delete(sight)
        saveContext()
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
        //Immigration Museum
        let _ = addSight(name: "Immigration Museum", desc: "Explore Melbourne's history through stories of people from across the world who have migrated to Victoria at the Immigration Museum.\nFrom the reasons for making the journey, to the moment of arrival in a new country, and the impact on indigenous communities - these stories are sometimes sad, sometimes funny, but always engaging. The result is a thought-provoking and moving experience.\nTake a fresh look at what it means to belong and not belong in Australia. Explore who Australians are and who others think Australians are.\nOpen daily, 10:00am to 5:00pm. Closed Good Friday and Christmas Day.", icon: "Flinders Icon" , photo: "immigration_museum", lat: -37.818948 , long: 144.960497)
        //Manchester Unity Building
         let _ = addSight(name: "Manchester Unity Building", desc: "The Manchester Unity Building is one of Melbourne's most iconic Art Deco landmarks. It was built in 1932 for the Manchester Unity Independent Order of Odd Fellows (IOOF), a friendly society providing sickness and funeral insurance. Melbourne architect Marcus Barlow took inspiration from the 1927 Chicago Tribune Building. His design incorporated a striking New Gothic style façade of faience tiles with ground-floor arcade and mezzanine shops, café and rooftop garden. Step into the arcade for a glimpse of the marble interior, beautiful friezes and restored lift – or book a tour for a peek upstairs.", icon: "Flinders Icon" , photo: "manchester_building", lat: -37.815132 , long: 144.966374)
        //Public Record Office
        let _ = addSight(name: "Public Record Office Victoria", desc: "Public Record Office Victoria holds a vast array of records created by Victorian Government departments and authorities including the State's courts, local councils, schools, public hospitals and other public offices.", icon: "Flinders Icon" , photo: "public_record", lat: -37.796358 , long: 144.942314)
        //Royal Botanic Gardens
        let _ = addSight(name: "Royal Botanic Gardens", desc: "Attracting over 1,900,000 visitors annually, Melbourne Gardens is a treasured part of cultural life and a valuable asset to the heritage rich city. With its stunning vistas, tranquil lakes and diverse plant collections, the Gardens are a place of continual discovery and delight.", icon: "Flinders Icon" , photo: "botanic_garden", lat: -37.831502 , long: 144.979310)
        //Federation Square
        let _ = addSight(name: "Federation Square", desc: "It is increasingly hard to imagine Melbourne without Federation Square. As a home to major cultural attractions, world-class events, tourism experiences and an exceptional array of restaurants, bars and specialty stores, this modern piazza has become the city's meeting place.", icon: "Flinders Icon" , photo: "fed_square", lat: -37.817895 , long: 144.969094)

        //let _ = addSight(name: "Parliament", desc: "Something", icon: "more something", photo: "luffy")
        //let _ = addSight(name: "WOW", desc: "WTF", icon: "HOW MUCH", photo: "")
        
    }
    
}


