//
//  EditSightViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit

class EditSightViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var icon: UITextField!
    
    @IBOutlet weak var photo: UIImageView!
    
    var sight: Place?
    
    weak var databaseController: DatabaseProtocol?
    
    
    
    
    
    @IBAction func imageClicked(_ sender: Any) {
        let changePhotoAlert = UIAlertController(title: "Change Photo", message: "You can change the photo of this location to the one you desire!", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .destructive) { (action: UIAlertAction) in
            // Code to take photo
            let controller = UIImagePickerController()
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                controller.sourceType = .camera
            } else {
                controller.sourceType = .photoLibrary
            }
            
            controller.allowsEditing = false
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
            
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .destructive) { (action: UIAlertAction) in
            let controller = UIImagePickerController()
            controller.sourceType = .photoLibrary
            controller.allowsEditing = false
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        changePhotoAlert.addAction(cameraAction)
        changePhotoAlert.addAction(galleryAction)
        changePhotoAlert.addAction(cancelAction)
        self.present(changePhotoAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            photo.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        name.text = sight?.name
        desc.text = sight?.desc
        icon.text = sight?.icon
        
        if let _ = UIImage(named: sight?.photo ?? "none") {
            photo.image = UIImage(named: sight?.photo ?? "none")
        } else {
            photo.image = loadImageData(fileName: sight?.photo ?? "none")
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
    
    
    
    
    
    
    @IBAction func cancelSightChanges(_ sender: Any) {
        //self.navigationController?.popToViewController( UIViewController, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveSightChanges(_ sender: Any) {
        let image = photo.image
        var data = Data()
        data = (image?.jpegData(compressionQuality: 0.8)!)!
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let date = UInt(Date().timeIntervalSince1970)
        
        if let pathComponent = url.appendingPathComponent("\(date)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data,
                                   attributes: nil)
        }
        
        sight?.name = name.text!
        sight?.desc = desc.text!
        sight?.icon = icon.text!
        sight?.photo = "\(date)"
        
        let _ = databaseController!.updateSight()
        
        navigationController?.popViewController(animated: true)
        
        
        
        
        
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
