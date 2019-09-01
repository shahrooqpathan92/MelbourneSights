//
//  EditSightViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class EditSightViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var icon: UITextField!
    
    var sight: Sight?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = sight?.sightName
        desc.text = sight?.sightDesc
        icon.text = sight?.sightIcon
        
    }
    

    @IBAction func cancelSightChanges(_ sender: Any) {
        //self.navigationController?.popToViewController( UIViewController, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveSightChanges(_ sender: Any) {
        sight?.sightName = name.text!
        sight?.sightDesc = desc.text!
        sight?.sightIcon = icon.text!
        
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
