//
//  MapViewController.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 5/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, DatabaseListener, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var databaseController: DatabaseProtocol?
    
    var allSights:[Place] = []
    
    var selectedSightName: String = ""
    
    var selectedSight: Place? = nil
    
    var focusedSight: Place? = nil
    
    func onSightListChange(change: DatabaseChange, sights: [Place]) {
        allSights = sights
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Checking if the default sight is nil
        if focusedSight == nil {
            let zoomRegion = MKCoordinateRegion(center: .init(latitude: -37.8183, longitude: 144.9671), latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
            mapView.setCenter(CLLocationCoordinate2DMake(-37.8183, 144.9671), animated: true)
            print("DEFAULT ZOOM")
        }
        else {
            print("To implement map zoom")
            focusOn(annotation: LocationAnnotation(newTitle: (focusedSight?.name)!, newSubtitle: (focusedSight?.icon)!, lat: (focusedSight?.lat)!, long: (focusedSight?.long)!))
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //var location = LocationAnnotation(newTitle: "Monash Uni - Caulfield", newSubtitle: "The Caulfield campus of the Uni", lat: -37.877623, long: 145.045374)
        
        //locationList.append(location)
        //self.mapView.addAnnotation(location)
        //location = LocationAnnotation(newTitle: "Monash Uni - Clayton", newSubtitle: "The Main Campus", lat: -37.9105238, long: 145.1362182)
        //self.mapView.addAnnotation(location)
        
        //focusOn(annotation: location)
        
        allSights = (databaseController?.fetchAllPlaces())!
        
        for sight in allSights {
            //print(sight.name!)
            let location = LocationAnnotation(newTitle: sight.name!, newSubtitle: sight.icon!, lat: sight.lat, long: sight.long)
            self.mapView.addAnnotation(location)
            //focusOn(annotation: location)
        }
        
        //focusOn(annotation: MKAnnotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.viewDidLoad()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
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
        }
        return view
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
}
