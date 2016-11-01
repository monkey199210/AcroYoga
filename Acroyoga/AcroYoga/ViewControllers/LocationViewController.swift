//
//  LocationViewController.swift
//  TurnUP
//
//  Created by SCAR on 3/20/16.
//  Copyright © 2016 ku. All rights reserved.
//
import Foundation
import CoreLocation
import MapKit

class LocationViewController : UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    @IBOutlet weak var btn_next: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        map.bringSubviewToFront(btn_next)
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.map.setRegion(region, animated: true)
//        let information = MKPointAnnotation()
//        information.coordinate = center
//        information.title = "Location!"
//        information.subtitle = "current position"
//        
//        self.map.addAnnotation(information)
        
    }
    @IBAction func btn_Next_Click(sender: AnyObject) {
        
//        let app = UIApplication.sharedApplication().delegate as? AppDelegate
//       
//            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController")
//            app!.setRootViewController(vc)
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        appDelegate!.loadPageController()
        
        
    }
}

