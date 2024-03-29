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
    
    func addSight(name: String, desc: String, icon: String, photo: String, lat: Double, long: Double, shortdesc: String) -> Place {
        
        let sight = NSEntityDescription.insertNewObject(forEntityName:"Place" , into: persistantContainer.viewContext) as! Place
        sight.name = name;
        sight.desc = desc;
        sight.icon = icon;
        sight.photo = photo;
        sight.lat = lat;
        sight.long = long;
        sight.shortdesc = shortdesc;
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
        //1. Immigration Museum
        let _ = addSight(name: "Immigration Museum", desc: "Explore Melbourne's history through stories of people from across the world who have migrated to Victoria at the Immigration Museum.\nFrom the reasons for making the journey, to the moment of arrival in a new country, and the impact on indigenous communities - these stories are sometimes sad, sometimes funny, but always engaging. The result is a thought-provoking and moving experience.\nTake a fresh look at what it means to belong and not belong in Australia. Explore who Australians are and who others think Australians are.\nOpen daily, 10:00am to 5:00pm. Closed Good Friday and Christmas Day.", icon: "green" , photo: "immigration_museum", lat: -37.818948 , long: 144.960497, shortdesc: "Museum of Immigration")
        //2. Manchester Unity Building
        let _ = addSight(name: "Manchester Unity Building", desc: "The Manchester Unity Building is one of Melbourne's most iconic Art Deco landmarks. It was built in 1932 for the Manchester Unity Independent Order of Odd Fellows (IOOF), a friendly society providing sickness and funeral insurance. Melbourne architect Marcus Barlow took inspiration from the 1927 Chicago Tribune Building. His design incorporated a striking New Gothic style façade of faience tiles with ground-floor arcade and mezzanine shops, café and rooftop garden. Step into the arcade for a glimpse of the marble interior, beautiful friezes and restored lift – or book a tour for a peek upstairs.", icon: "green" , photo: "manchester_building", lat: -37.815132 , long: 144.966374, shortdesc: "Melbourne's most iconic Art Deco")
        //3. Public Record Office
        let _ = addSight(name: "Public Record Office Victoria", desc: "Public Record Office Victoria holds a vast array of records created by Victorian Government departments and authorities including the State's courts, local councils, schools, public hospitals and other public offices.", icon: "red" , photo: "public_record", lat: -37.796358 , long: 144.942314, shortdesc: "Holds a vast array of records")
        //4. Royal Botanic Gardens
        let _ = addSight(name: "Royal Botanic Gardens", desc: "Attracting over 1,900,000 visitors annually, Melbourne Gardens is a treasured part of cultural life and a valuable asset to the heritage rich city. With its stunning vistas, tranquil lakes and diverse plant collections, the Gardens are a place of continual discovery and delight.", icon: "green" , photo: "botanic_garden", lat: -37.831502 , long: 144.979310, shortdesc: "A place of continual discovery and delight")
        //5. Federation Square
        let _ = addSight(name: "Federation Square", desc: "It is increasingly hard to imagine Melbourne without Federation Square. As a home to major cultural attractions, world-class events, tourism experiences and an exceptional array of restaurants, bars and specialty stores, this modern piazza has become the city's meeting place.", icon: "blue" , photo: "fed_square", lat: -37.817895 , long: 144.969094, shortdesc: "Like a City Square!")
        //6. Heritage Walk
        let _ = addSight(name: "Aboriginal Heritage Walk", desc: "Womin Djeka. Journey into the ancestral lands of the Kulin (Koolin) Nation in this 90 minute tour with an Aboriginal guide. Gain insight into the rich history and thriving culture of the local First Peoples, and discover their connection to plants and their traditional uses for food, tools and medicine.", icon: "blue" , photo: "abo_walk", lat: -37.830208 , long: 144.976840, shortdesc: "Aborginal Walk Tours")
        //7. Sports Museum
        let _ = addSight(name: "National Sports Museum at the MCG", desc: "The MCG recognises and celebrates its heritage and sporting history with a commitment seen at very few stadiums anywhere in the world by housing the National Sports Museum. Across a multitude of sports, the museum features memorabilia from some of the country's biggest heroes and highlights moments that have shaped the traditions of Australian sport.", icon: "blue" , photo: "sport_muse", lat: -37.815946 , long: 144.982094, shortdesc: "Sports Museum for enjoyment")
        //8. Abbotsford Convent
        let _ = addSight(name: "Abbotsford Convent", desc: "Just four kilometres from Melbourne’s CBD and spread over 16 acres, the Abbotsford Convent – with its 11 historic buildings and gardens – is Australia’s largest multi-arts precinct. The former Convent of the Good Shepherd, this ex-monastic site is now owned by the Abbotsford Convent Foundation (ACF) – a not-for-profit organisation that operates the Abbotsford Convent on behalf of the public. ", icon: "blue" , photo: "convent", lat: -37.801935 , long: 145.004272, shortdesc: "A very beautiful convent")
        //9. Parkville
        let _ = addSight(name: "Parkville Heritage Walks", desc: "Parkville Heritage Walks offers self-guided walking tours of historical South Parkville, Melbourne's premier heritage-listed residential precinct.", icon: "red" , photo: "parkville", lat: -37.794379 , long: 144.954880, shortdesc: "Self Guided Tour")
        //10. Portable Iron Houses
        let _ = addSight(name: "Portable Iron Houses", desc: "The nineteenth century Portable Iron Houses provide an insight into life in Emerald Hill, now known as South Melbourne, during the gold rush years.", icon: "green" , photo: "iron_house", lat: -37.833625 , long: 144.955019, shortdesc: "Iron Houses from gold rush")

    }
    
}


