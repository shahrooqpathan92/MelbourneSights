	//
//  AddNewSightViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class AddNewSightViewController: UIViewController {

    //weak var sightDelegate: AddSightDelegate?
    weak var databaseController: DatabaseProtocol?
    
    
    @IBOutlet weak var iconTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
    }
    
    
    
 	   @IBAction func createSight(_ sender: Any) {
        
        if nameTextField.text != "" && descTextField.text != "" && iconTextField.text != "" {
            let name = nameTextField.text!
            let desc = descTextField.text!
            let icon = iconTextField.text!
            let photo = ""
            let lat = 0
            let long = 0
            //let sight = Sight(sightName: name, sightDesc: desc, sightIcon: icon)
            //let _ = sightDelegate?.addSight(newSight: sight)
            let _ = databaseController!.addSight(name: name, desc: desc, icon: icon, photo: photo, lat : Double(lat) , long : Double(long))
            navigationController?.popViewController(animated: true)
            return
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
