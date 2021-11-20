//
//  ViewController.swift
//  MobileMapper2021
//
//  Created by Christopher Walter on 11/20/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate
{

    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    
    var parks: [MKMapItem] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[0]
        print(currentLocation)
    }
    

    @IBAction func zoomButtonTapped(_ sender: UIBarButtonItem)
    {
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parks"
        request.region = mapView.region
        
        
        let search = MKLocalSearch(request: request)
        
        search.start {
            (response, error) in
            guard let response = response else {
                print("No response")
                return
            }
            
            print(response)
            
            for mapItem in response.mapItems
            {
                print(mapItem)
                self.parks.append(mapItem)
                
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
            
        }
        
        
    }
    

}

