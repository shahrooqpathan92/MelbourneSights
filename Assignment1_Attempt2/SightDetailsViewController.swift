//
//  SightDetailsViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class SightDetailsViewController: UIViewController {
    
    var sight: Place?
    
    @IBOutlet weak var sightName: UILabel!
    @IBOutlet weak var sightDetails: UILabel!
    
    @IBOutlet weak var sightPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WTF")
        if sight != nil {
            sightName.text = sight?.name
            sightDetails.text = sight?.desc
            print(sight?.photo ?? "nothing here")
            
            if let _ = UIImage(named: sight?.photo ?? "none") {
                sightPhoto.image = UIImage(named: sight?.photo ?? "none")
            } else {
                sightPhoto.image = loadImageData(fileName: sight?.photo ?? "none")
            }
        }
        
    }
    
    
    
    func loadImageData(fileName: String) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            let fileData = fileManager.contents(atPath: filePath)
            image = UIImage(data: fileData!)
        }
        
        return image
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSightSegue" {
            let controller = segue.destination as! EditSightViewController
            controller.sight = sight
        }
    }
    
    //To refresh view
    override func viewWillAppear(_ animated: Bool) {
        //self.viewDidLoad()
        self.viewDidLoad()
    }
    
}
