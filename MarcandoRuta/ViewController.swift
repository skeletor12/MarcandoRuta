//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Luis Rodriguez on 06/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
 
    @IBOutlet weak var zoom: UISlider!
    
    @IBOutlet weak var mapa: MKMapView!
    @IBAction func normal(sender: AnyObject) {
       mapa.mapType = MKMapType.Standard
    }
    
    @IBAction func satelite(sender: AnyObject) {
        mapa.mapType = MKMapType.Satellite
    }
    
    @IBAction func hibrido(sender: AnyObject) {
        mapa.mapType = MKMapType.Hybrid
    }
    
    let manejador = CLLocationManager()
    var Fin: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.desiredAccuracy = kCLLocationAccuracyKilometer;
        manejador.requestWhenInUseAuthorization()
        manejador.startMonitoringSignificantLocationChanges()
        Fin = manejador.location
        manejador.distanceFilter = 50

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let center = CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
     
        let zoomx = Double(zoom.value)
        let zoomin = zoomx * 0.005
        
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(zoomin, zoomin))
        self.mapa.setRegion(region, animated: true)
        
        let distancia = Fin?.distanceFromLocation(locations.last!)
        //let distanciar = round(distancia!)
        
        var punto = CLLocationCoordinate2D()
        punto.latitude = (manager.location?.coordinate.latitude)!
        punto.longitude = (manager.location?.coordinate.longitude)!
        
        let pin = MKPointAnnotation()
        pin.title = "Lat. \(String(format:"%4.4f", punto.latitude)), Long. \(String(format:"%4.4f",punto.longitude))"
        pin.subtitle = "Distancia \(String(format:"%7.2f",distancia!)) Mts"
        pin.coordinate = punto
        mapa.addAnnotation(pin)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error porque = \(error.localizedFailureReason)")
    }
    
}

