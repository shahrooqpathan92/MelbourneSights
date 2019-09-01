//
//  SightDetailsViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class SightDetailsViewController: UIViewController {
    
    var sight: Sight?
    
    @IBOutlet weak var sightName: UILabel!
    @IBOutlet weak var sightDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sight != nil {
            sightName.text = sight?.sightName
            sightDetails.text = sight?.sightDesc
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSightSegue" {
            let controller = segue.destination as! EditSightViewController
            controller.sight = sight
        }
    }
 

}
