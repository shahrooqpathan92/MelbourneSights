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

//enum ListenerType{
//    case sight
//    case all
//}

protocol DatabaseListener: AnyObject {
    //var listenerType: ListenerType {get set}
    func onSightListChange(change: DatabaseChange, sights: [Place])
}


protocol DatabaseProtocol: AnyObject {
    //var defaultPlaces: Place{get}
    func addSight(name : String, desc : String, icon : String) -> Place
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
