//
//  SightListTableViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 31/8/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class SightListTableViewController: UITableViewController , UISearchResultsUpdating, DatabaseListener {
    
    
    //var listenerType: ListenerType.Type
    
    @IBAction func goBackToMap(_ sender: Any) {
        //print("LOLOLOLOL")
        //self.navigationController?.popToRootViewController(animated: true)
        performSegue(withIdentifier: "showMapWithLocation", sender: view)
    }
    
  
    @IBAction func goToMap(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    func addSight(newSight: Place) -> Bool {
        allSights.append(newSight)
        filteredSights.append(newSight)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredSights.count - 1 , section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_COUNT], with: .automatic)
        print("does it come here")
        return true
    }
    
    
    let SECTION_PLACES = 0;
    let SECTION_COUNT = 1;
    let CELL_SIGHT = "sightCell"
    let CELL_COUNT = "totalSightsCell"
    
    var allSights:[Place] = []
    var filteredSights:[Place] = []
    
    weak var sightDelegate: AddSightDelegate?
    weak var databaseController: DatabaseProtocol?
    //TESTING
    weak var mapController: MapViewController?
    
    
    weak var selectedSightFromList: Place? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createDefaultSights()
        //filteredSights = allSights
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        
        
        //Adding a Search Controller with proper settings
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(),searchText.count > 0 {
            filteredSights = allSights.filter({(sight: Place) -> Bool in
                return (sight.name?.lowercased().contains(searchText))!
            })
        }
        else {
            filteredSights = allSights
        }
        
        tableView.reloadData();
    }
    
    
    //    func createDefaultSights() {
    //        allSights.append(Sight(sightName: "Flinders Street Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
    //        allSights.append(Sight(sightName: "Parliament Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
    //        allSights.append(Sight(sightName: "Melbourne Central Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
    //        allSights.append(Sight(sightName: "Southbank Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
    //        allSights.append(Sight(sightName: "Southern Cross Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
    //        allSights.append(Sight(sightName: "Flagstaff Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
    //
    //    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_PLACES {
            return filteredSights.count
        }else {
            return 1
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_PLACES {
            
            let placeCell = tableView.dequeueReusableCell(withIdentifier: CELL_SIGHT, for: indexPath) as!
            SightTableViewCell
            
            let place = filteredSights[indexPath.row]
            
            placeCell.nameLabel.text = place.name
            placeCell.descLabel.text = place.desc
            
            return placeCell
        }
        let countcell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        countcell.textLabel?.text = "\(allSights.count) sights in the database"
        countcell.selectionStyle = .none
        return countcell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_COUNT {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        //let mapView = MapViewController()
        //mapView.focusedSight  = filteredSights[selectedIndexPath!.row]
        let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
        //mapView.focusedSight = filteredSights[selectedIndexPath!.row]
       
        //mapController?.focusedSight = filteredSights[selectedIndexPath!.row]
        
        
        selectedSightFromList = filteredSights[selectedIndexPath!.row]
        
        
        
        
        //print(mapController?.focusedSight)
        print("NEXTLINE")
        //mapController?.focusOn(annotation: LocationAnnotation(newTitle: selectedSight.name!
            //, newSubtitle: selectedSight.icon!, lat: selectedSight.lat, long: selectedSight.long) )
        //print(filteredSights[selectedIndexPath!.row].name)
        //navigationController?.popViewController(animated: true)
        
        //        if (sightDelegate!.addSight(newSight: filteredSights[indexPath.row])){
        //            navigationController?.popViewController(animated: true)
        //            return
        //        }
        
        
        performSegue(withIdentifier: "showMapWithLocation", sender: view)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //var listenerType: ListenerType
    
    func onSightListChange(change: DatabaseChange, sights: [Place]) {
        allSights = sights
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SightDetailSegue" {
            let controller = segue.destination as! SightDetailsViewController
            let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            controller.sight = filteredSights[selectedIndexPath!.row]
        }
        
        //        if segue.identifier == "AddSightSegue" {
        //            let destination = segue.destination as! AddNewSightViewController
        //            //destination.sightDelegate = self
        //        }
        if segue.identifier == "showMapWithLocation" {
            let controller = segue.destination as! MapViewController
           // let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            controller.focusedSight = selectedSightFromList
        }
        
        
    }
    
    
}

