//
//  ViewController.swift
//  Lab05_GPS_MAP
//
//  Created by Student on 2019-10-13.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let MAX_SPEED: Double = 115
    
    var locationManager =  CLLocationManager()
    var previousSpeed : CLLocationSpeed = CLLocationSpeed()
    var currentSpeed: CLLocationSpeed = CLLocationSpeed()
    var maxSpeed : CLLocationSpeed = CLLocationSpeed()
    var currentLocation : CLLocation = CLLocation()
    var previousLocation : CLLocation = CLLocation()
    var distance: CLLocationDistance = CLLocationDistance()
    var maxAcceleration : Double  = 0
    var isBeginning : Bool = false
    
    var isStarted = false
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var maxAccelerationLabel: UILabel!
    @IBOutlet weak var bottomBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startTrip(_ sender: Any) {
        isStarted = true
        resetValue()
        bottomBarView.backgroundColor = UIColor.green
    }
    @IBAction func stopTrip(_ sender: Any) {
        isStarted = false
        bottomBarView.backgroundColor = UIColor.gray
    }
    func resetValue(){
        previousSpeed = 0;
        currentSpeed = 0;
        maxSpeed = 0;
        distance = 0;
        maxAcceleration = 0
        currentSpeedLabel.text! = "0 km/h"
        averageSpeedLabel.text! = "0 km/h"
        distanceLabel.text! = "0 km"
        maxSpeedLabel.text! = "0 km/h"
        maxAccelerationLabel.text! = "0 m/s^2"
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(isStarted){
            trackingMoving(location: locations[0])
        
        } else {
            topBarView.backgroundColor = UIColor.gray
            currentSpeedLabel.text! = "0 km/h"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resetValue()
    }
    
    func trackingMoving(location: CLLocation){
        let zoomRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 400)
        mapView.setRegion(zoomRegion, animated: true)
        previousLocation = currentLocation
        currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        previousSpeed = currentSpeed
        currentSpeed = locationManager.location!.speed

        
        if(CLLocationCoordinate2DIsValid(previousLocation.coordinate) && CLLocationCoordinate2DIsValid(currentLocation.coordinate)) {
            let currentDistance = currentLocation.distance(from: previousLocation)
            if(currentDistance < 1000){
                if(currentDistance == 0 ){
                    currentSpeed = 0
                }
                getSpeedInfo(currentDistance: currentDistance)
                distance +=  currentDistance
                distanceLabel.text! = String(Double(round((distance/1000) * 100)/100)) + " km"
            }
            
        }
    }
    
    
    func getSpeedInfo(currentDistance : CLLocationDistance){
        if(currentSpeed * 3.6 > MAX_SPEED) {
            topBarView.backgroundColor = UIColor.red
        } else {
            topBarView.backgroundColor = UIColor.green
        }
        if(currentSpeed > maxSpeed) {
            maxSpeed = currentSpeed
        }
        currentSpeedLabel.text! = String(Double(round(currentSpeed * 3.6 * 100)/100)) + " km/h"
        maxSpeedLabel.text! = String(Double(round(maxSpeed * 3.6 * 100)/100)) + " km/h"
        averageSpeedLabel.text! = String(Double(round(currentDistance * 3.6 * 100)/100)) + " km/h"
        
        let acceleration = abs(currentSpeed - previousSpeed)
        if(acceleration > maxAcceleration && distance > 0){
            maxAcceleration = acceleration
        }
        maxAccelerationLabel.text! = String(Double(round(maxAcceleration * 1000) / 1000)) + " m/s^2"
    }
    

}

