//
//  EditSightViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit
import MapKit

class EditSightViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var iconPicker: UIPickerView!
    @IBOutlet weak var photo: UIImageView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    var sight: Place?
    
    weak var databaseController: DatabaseProtocol?
    
    var pickerData: [String] = [String]()
    
    let annotation = MKPointAnnotation()
    
    var tempLat: Double?
    var tempLong: Double?
    
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
        
        //Setting the picker delegate
        iconPicker.delegate = self
        iconPicker.dataSource = self
        pickerData = ["red","green","blue"]
        //Setting Map View Delegate
        
        mapView.delegate = self
        name.text = sight?.name
        desc.text = sight?.desc
        //icon.text = sight?.icon
        
        switch sight?.icon {
        case "red":
            iconPicker.selectRow(0, inComponent: 0, animated: false)
        case "green":
            iconPicker.selectRow(1, inComponent: 0, animated: false)
        case "blue":
            iconPicker.selectRow(2, inComponent: 0, animated: false)
        default:
            print("no color exists")
        }
        
        
        
        if let _ = UIImage(named: sight?.photo ?? "none") {
            photo.image = UIImage(named: sight?.photo ?? "none")
        } else {
            photo.image = loadImageData(fileName: sight?.photo ?? "none")
        }
        
        
        //Reference: https://stackoverflow.com/questions/33188663/how-to-drag-an-annotation-with-mkmapview-being-dragged-ios
        let coordinate = CLLocationCoordinate2DMake((sight?.lat)!, (sight?.long)!)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
        
        
        annotation.coordinate = coordinate
        annotation.title = sight?.name
        annotation.subtitle = sight?.shortdesc
        self.mapView.addAnnotation(annotation)
        
        
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Remove all annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        tempLat = (pinView?.annotation?.coordinate.latitude)!
        tempLong = (pinView?.annotation?.coordinate.longitude)!
        return pinView
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
        sight?.icon = pickerData[iconPicker.selectedRow(inComponent: 0)]
        sight?.photo = "\(date)"
        
        if tempLat != nil {
            sight?.lat = tempLat!
        }
        if tempLong != nil {
            sight?.long = tempLong!
        }
        
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
