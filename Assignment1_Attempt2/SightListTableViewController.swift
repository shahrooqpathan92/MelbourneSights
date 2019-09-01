//
//  SightListTableViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 31/8/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class SightListTableViewController: UITableViewController , UISearchResultsUpdating, AddSightDelegate {
    
    
    func addSight(newSight: Sight) -> Bool {
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
    
    var allSights:[Sight] = []
    var filteredSights:[Sight] = []
    
    weak var sightDelegate: AddSightDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDefaultSights()
        filteredSights = allSights
        
        
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
            filteredSights = allSights.filter({(sight: Sight) -> Bool in
                return sight.sightName.lowercased().contains(searchText)
            })
        }
        else {
            filteredSights = allSights
        }
        
        tableView.reloadData();
    }

    
    func createDefaultSights() {
        allSights.append(Sight(sightName: "Flinders Street Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
        allSights.append(Sight(sightName: "Parliament Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
        allSights.append(Sight(sightName: "Melbourne Central Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
        allSights.append(Sight(sightName: "Southbank Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
        allSights.append(Sight(sightName: "Southern Cross Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
        allSights.append(Sight(sightName: "Flagstaff Station", sightDesc: "Probably the most important station of Melbourne", sightIcon: "To be Implemented"))
        
    }

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

           placeCell.nameLabel.text = place.sightName
           placeCell.descLabel.text = place.sightDesc

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
        
//        if (sightDelegate!.addSight(newSight: filteredSights[indexPath.row])){
//            navigationController?.popViewController(animated: true)
//            return
//        }
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
        
        if segue.identifier == "AddSightSegue" {
            let destination = segue.destination as! AddNewSightViewController
            destination.sightDelegate = self
        }
        
    }
 

}

