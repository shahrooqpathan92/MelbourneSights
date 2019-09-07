//
//  SightListTableViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 31/8/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class SightListTableViewController: UITableViewController , UISearchResultsUpdating, DatabaseListener {
    
    //Function to go back to map
    @IBAction func goBackToMap(_ sender: Any) {
        performSegue(withIdentifier: "showMapWithLocation", sender: view)
    }
    
    //Function to sort based on segment
    @IBAction func sort(_ sender: UISegmentedControl) {
        //Sorting by ascending
        if sender.selectedSegmentIndex == 0 {
            filteredSights = filteredSights.sorted{ $0.name!.lowercased() < $1.name!.lowercased() }
        }
        //Sorting by descending
        if sender.selectedSegmentIndex == 1 {
            filteredSights = filteredSights.sorted{ $0.name!.lowercased() > $1.name!.lowercased() }
        }
        tableView.reloadData()
    }
    
    let SECTION_PLACES = 1;
    let SECTION_COUNT = 2;
    let SECTION_SORT = 0;
    let CELL_SIGHT = "sightCell"
    let CELL_COUNT = "totalSightsCell"
    let CELL_SORT = "sortCell"
    
    var allSights:[Place] = []
    var filteredSights:[Place] = []
    
    weak var sightDelegate: AddSightDelegate?
    weak var databaseController: DatabaseProtocol?
    weak var mapController: MapViewController?
    
    
    weak var selectedSightFromList: Place? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            placeCell.descLabel.text = place.shortdesc
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.height, height: tableView.frame.height))
            imageView.image = UIImage(named: place.icon!)
            placeCell.sightImage.image = UIImage(named: "\(place.icon!)_glyph_color")
            print("SORT PLACES")
            return placeCell
        }
        
        if indexPath.section == SECTION_SORT {
            let sortcell = tableView.dequeueReusableCell(withIdentifier: CELL_SORT, for: indexPath)
            print("SORT CELL")
            return sortcell
        }
        let countcell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        countcell.textLabel?.text = "\(allSights.count) sights in the database"
        countcell.selectionStyle = .none
        return countcell
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == SECTION_COUNT || indexPath.section == SECTION_SORT {
            return UITableViewCell.EditingStyle.none
        }else{
            return UITableViewCell.EditingStyle.delete
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_COUNT || indexPath.section == SECTION_SORT {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
        
        selectedSightFromList = filteredSights[selectedIndexPath!.row]
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //To Delelte the rows from tablieview and save to coreData
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete && indexPath.section == SECTION_PLACES) {
            
            databaseController?.deleteSight(sight: filteredSights[indexPath.row])
            
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SightDetailSegue" {
            let controller = segue.destination as! SightDetailsViewController
            let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            controller.sight = filteredSights[selectedIndexPath!.row]
        }
        
        if segue.identifier == "showMapWithLocation" {
            let controller = segue.destination as! MapViewController
            controller.focusedSight = selectedSightFromList
        }
        
        
    }
    
    
}

