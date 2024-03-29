//
//  DatabaseProtocol.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 3/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

enum DatabaseChange{
    case add
    case remove
    case update
    
}

protocol DatabaseListener: AnyObject {
    //var listenerType: ListenerType {get set}
    func onSightListChange(change: DatabaseChange, sights: [Place])
}


protocol DatabaseProtocol: AnyObject {
    //var defaultPlaces: Place{get}
    func addSight(name: String, desc: String, icon: String, photo: String, lat: Double, long: Double, shortdesc: String) -> Place
    func updateSight() -> Bool
    func fetchAllPlaces() -> [Place]
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func getSight(name: String) -> Place?
    func deleteSight(sight: Place)
}
