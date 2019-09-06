//
//  MapViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 5/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, DatabaseListener, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var databaseController: DatabaseProtocol?
    
    var allSights:[Place] = []
    
    var selectedSightName: String = ""
    
    var selectedSight: Place? = nil
    
    var focusedSight: Place? = nil
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var geoLocation = CLCircularRegion()
    
    func onSightListChange(change: DatabaseChange, sights: [Place]) {
        allSights = sights
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To hide the navigation button 
        navigationItem.hidesBackButton = true
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        
        
        //Setting the user location
        mapView.showsUserLocation = true
        //Checking if the default sight is nil
        if focusedSight == nil {
            let zoomRegion = MKCoordinateRegion(center: .init(latitude: -37.8183, longitude: 144.9671), latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
            mapView.setCenter(CLLocationCoordinate2DMake(-37.8183, 144.9671), animated: true)
            print("DEFAULT ZOOM")
        }
        else {
            print("To implement map zoom")
            focusOn(annotation: LocationAnnotation(newTitle: (focusedSight?.name)!, newSubtitle: (focusedSight?.icon)!, lat: (focusedSight?.lat)!, long: (focusedSight?.long)!, icon: (focusedSight?.icon)!, image: (focusedSight?.photo)!))
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        databaseController = appDelegate.databaseController
        
        allSights = (databaseController?.fetchAllPlaces())!
        
        //Top Stop monitoring all locations (i.e refreshing all geofences)
        let existingGeofences = locationManager.monitoredRegions
        
        for geofence in existingGeofences{
            locationManager.stopMonitoring(for: geofence)
        }
        
        for sight in allSights {
            //print(sight.name!)
            let location = LocationAnnotation(newTitle: sight.name!, newSubtitle: sight.shortdesc!, lat: sight.lat, long: sight.long, icon: sight.icon!, image: sight.photo!)
            self.mapView.addAnnotation(location)
            geoLocation = CLCircularRegion(center: location.coordinate, radius: 50,
                                           identifier: location.title!)
            
            
            //testing geolocation
            geoLocation.notifyOnEntry = true
            geoLocation.notifyOnExit = true
            locationManager.startMonitoring(for: geoLocation)
            //focusOn(annotation: location)
        }
       
        
        
        
        //
        
        //focusOn(annotation: MKAnnotation)
        
    }
    
    func startMonitoring(_ manager:CLLocationManager, region:CLCircularRegion) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("Cannot monitor location")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            print("Please grant access")
        } else {
            let locationManager = CLLocationManager()
            locationManager.startMonitoring(for: region)
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region:
        CLRegion) {
        let alert = UIAlertController(title: "Movement Detected!", message: "You have left \(region.identifier)", preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "Movement Detected!", message: "You have entered \(region.identifier)", preferredStyle:
            UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("hello world")
    }
    
    //reference : https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LocationAnnotation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //view.image = UIImage(named: "luffy")
            view.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            view.image = nil
            if annotation.icon == "green" {
                view.markerTintColor = UIColor.green
            }
            if annotation.icon == "purple" {
                view.glyphImage = UIImage(named: "purple")
            }
            
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height))
            
            //imageView.image =  UIImage(named: annotation.image!)
            
            if let _ = UIImage(named: annotation.image ?? "none") {
                imageView.image = UIImage(named: annotation.image!)
            } else {
                imageView.image = loadImageData(fileName: annotation.image ?? "none")
            }
            
            
            
            imageView.contentMode = .scaleAspectFit
            
            view.leftCalloutAccessoryView = imageView
            
        }
        return view
        
        
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
    
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        //let location = view.annotation as! Artwork
        //let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        //location.mapItem().openInMaps(launchOptions: launchOptions)
        print("information clicked")
        selectedSightName = ((view.annotation?.title)!)!
        selectedSight = (databaseController?.getSight(name: selectedSightName))!
        
        
        performSegue(withIdentifier: "sightDetailsSegue", sender: view)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sightDetailsSegue" {
            let controller = segue.destination as! SightDetailsViewController
            
            controller.sight = selectedSight
        }
        
        if segue.identifier == "showAllSights" {
            //            let controller = segue.destination as! SightListTableViewController
            let controller = SightListTableViewController()
            controller.mapController = self
            
            //controller.sight = selectedSight
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location.coordinate
        
    }
}
