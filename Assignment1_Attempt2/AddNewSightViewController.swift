    //
    //  AddNewSightViewController.swift
    //  Assignment1_Attempt2
    //
    //  Created by Shahrooq Pathan on 1/9/19.
    //  Copyright © 2019 Shahrooq Pathan. All rights reserved.
    //
    
    import UIKit
    import MapKit
    
    class AddNewSightViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
        
        
        
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
        
        
        //weak var sightDelegate: AddSightDelegate?
        weak var databaseController: DatabaseProtocol?
        
        
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var photo: UIImageView!
        //@IBOutlet weak var iconTextField: UITextField!
        @IBOutlet weak var descTextField: UITextField!
        @IBOutlet weak var nameTextField: UITextField!
        
        //For icon picker
        @IBOutlet weak var iconPicker: UIPickerView!
        var pickerData: [String] = [String]()
        
        let annotation = MKPointAnnotation()
        
        var annotationCount: Int = 0
        
        var tempLat: Double = 0.00
        var tempLong: Double = 0.00
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            pickerData = ["red","green","blue"]
            
            
            
            
            //Get the database controller once from the App Delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController
            mapView.delegate = self
            
            //Setting the picker delegate
            iconPicker.delegate = self
            iconPicker.dataSource = self
            
            // Do any additional setup after loading the view, typically from a nib.
            //Reference: https://stackoverflow.com/questions/33188663/how-to-drag-an-annotation-with-mkmapview-being-dragged-ios
            let coordinate = CLLocationCoordinate2DMake(-37.818102, 144.967687)
            let span = MKCoordinateSpan.init(latitudeDelta: 0.003, longitudeDelta: 0.003)
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            mapView.setRegion(region, animated:true)
            
            
            annotation.coordinate = coordinate
            annotation.title = "New Location"
            annotation.subtitle = "Add this location"
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
        
        @IBAction func createSight(_ sender: Any) {
            
            if nameTextField.text != "" && descTextField.text != "" /* && iconTextField.text != "" */ {
                
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
                
                
                
                
                
                let name = nameTextField.text!
                let desc = descTextField.text!
                //let icon = iconTextField.text!
               
                let icon = pickerData[iconPicker.selectedRow(inComponent: 0)]
                let picture = "\(date)"
                let lat = tempLat
                let long = tempLong
                let shortdesc = "User added location"
                let _ = databaseController!.addSight(name: name, desc: desc, icon: icon, photo: picture, lat : Double(lat) , long : Double(long), shortdesc: shortdesc)
                navigationController?.popViewController(animated: true)
                return
                
            }
        }
    }
