//
//  ViewController.swift
//  Mapd
//
//  Created by newuser on 2019-03-07.
//  Copyright © 2019 newuser. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var previouspPoint: CLLocation?
    private var totalMovementDistance = CLLocationDistance(0)
    
    
    @IBOutlet weak var LatitudeLabel: UILabel!
    @IBOutlet weak var LongitudeLabel: UILabel!
    @IBOutlet weak var HorizontalAccuracyLabel: UILabel!
    @IBOutlet weak var AltitudeLabel: UILabel!
    @IBOutlet weak var VerticalAccuracyLabel: UILabel!
    @IBOutlet weak var DistanceTravelledLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to: \(status.rawValue)")
        switch (status){
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorType = error._code == CLError.denied.rawValue ? "Access Denied" : "Error \(error._code)"
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in})
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            let latitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.latitude)
            LatitudeLabel.text = latitudeString
            
            let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
            LongitudeLabel.text = longitudeString
            
            let horizontalAccuracyString = String(format: "%gm", newLocation.horizontalAccuracy)
            HorizontalAccuracyLabel.text = horizontalAccuracyString
            
            let altitudeString = String(format: "%gm", newLocation.altitude)
            AltitudeLabel.text = altitudeString
            
            let verticalAccuracyString = String(format: "%gm", newLocation.verticalAccuracy)
            VerticalAccuracyLabel.text = verticalAccuracyString
            
            if newLocation.horizontalAccuracy < 0 {
                return
            }
            if newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50 {
                return
            }
            
            if previouspPoint == nil {
                totalMovementDistance = 0
                let start = Place(title: "Start Point", subtitle: "This is where we started", coordinate: newLocation.coordinate)
                mapView.addAnnotation(start)
                let region = MKCoordinateRegion(center: newLocation.coordinate,latitudinalMeters: 100,longitudinalMeters: 100)
                mapView.setRegion(region, animated: true)
            }else {
                print("movement distance:" + "\(newLocation.distance(from: previouspPoint!))")
                totalMovementDistance += newLocation.distance(from: previouspPoint!)
            }
            previouspPoint = newLocation
            let distanceString = String(format: "%gm", totalMovementDistance)
            DistanceTravelledLabel.text = distanceString
    }
    
}

}
