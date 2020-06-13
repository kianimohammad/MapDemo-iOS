//
//  ViewController.swift
//  Map Demo
//
//  Created by Mohammad Kiani on 2020-06-12.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        map.delegate = self
        
//        this line is equivalent to the user location check box in map view
//        map.showsUserLocation = true
        
        // we give the delegate of locationManager to this class
        locationManager.delegate = self
        
        // accuracy of the location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // request the user for the location access
        locationManager.requestWhenInUseAuthorization()
        
        // start updating the location of the user
        locationManager.startUpdatingLocation()
 
        // 1 - define latitude and longitude
        let latitude: CLLocationDegrees = 43.64
        let longitude: CLLocationDegrees = -79.38
        
        displayLocation(latitude: latitude, longitude: longitude, title: "Toronto Downtown", subtitle: "beatiful city")
        
        // long press gesture
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(addlongPressAnnotation))
        map.addGestureRecognizer(uilpgr)
        
        // add double tap
        addDoubleTap()
        
    }
    
    //MARK: - add long press gesture recognizer for the annotation
    @objc func addlongPressAnnotation(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
        
        // add annotation
        let annotation = MKPointAnnotation()
        annotation.title = "My destination"
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
    }
    
    
    //MARK: - didupdatelocation method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        displayLocation(latitude: latitude, longitude: longitude, title: "Your Location", subtitle: "you are here")
        
        
    }
    
    //MARK: - display user location method
    func displayLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subtitle: String) {
        // 2 - define delta latitude and delta longitude for the span
        let latDelta: CLLocationDegrees = 0.05
        let lngDelta: CLLocationDegrees = 0.05
        
        // 3 - creating the span and location coordinate and finally the region
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        // 4 - set region for the map
        map.setRegion(region, animated: true)
        
        // add annotation
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = location
        map.addAnnotation(annotation)
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        doubleTap.numberOfTapsRequired = 2
        map.addGestureRecognizer(doubleTap)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin()
        
        // add annotation
        
        let touchPoint = sender.location(in: map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.title = "My destination"
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
    }
    
    func removePin() {
        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
//        map.removeAnnotations(map.annotations)
    }
}

extension ViewController: MKMapViewDelegate {
    //MARK: - add viewFor annotation method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
//        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
//        pinAnnotation.animatesDrop = true
//        pinAnnotation.pinTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        // add custom annotation with image
        let pinAnnotation = map.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
        pinAnnotation.image = UIImage(named: "ic_place_2x")
        pinAnnotation.canShowCallout = true
        pinAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pinAnnotation
    }
    
    //MARK: - callout accessory control tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alertController = UIAlertController(title: "Your Place", message: "Welcome", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
