//
//  MapViewController.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView?
    
    let regionRadius: CLLocationDistance = 500
    let mapService = MapService.sharedInstance
    let locationManager = CLLocationManager()
    
    var markers: [MapMarkerModel] = []
    
    override func viewDidLoad() {
        // Request user authentication
        self.locationManager.requestAlwaysAuthorization()
        
        // Use GPS in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Showing Map")
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(MapViewController.updateOnRequestsUpdatedNotification),
            name: Config.requestsUpdatedNotificationKey,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(MapViewController.updateOnOffersUpdatedNotification),
            name: Config.offersUpdatedNotificationKey,
            object: nil)
        
        updateMarkers()
    }
    
    func updateMarkers() {
        print("Set requests and offers")
        if let model = mapService.mapViewModel {
            print(model)
            if let requests = model.requests {
                for request in requests {
                    addMapMarkerToMap(MapMarkerModel(
                        title: request.title,
                        locationName: "",
                        discipline: Config.offerDiscipline,
                        coordinate: request.location
                    ))
                }
            }
            if let offers = model.offers {
                for offer in offers {
                    addMapMarkerToMap(MapMarkerModel(
                        title: offer.title,
                        locationName: "",
                        discipline: Config.offerDiscipline,
                        coordinate: offer.location
                    ))
                }
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        print("centerMapOnLocation called")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func addMapMarkerToMap(marker: MapMarkerModel) {
        mapView?.addAnnotation(marker)
    }
    
    func updateOnRequestsUpdatedNotification() {
        updateMarkers()
    }
    
    func updateOnOffersUpdatedNotification() {
        updateMarkers()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)! {
            let curLat: CLLocationDegrees = locValue.latitude
            let curLon: CLLocationDegrees = locValue.longitude                        
            centerMapOnLocation(CLLocation(latitude: curLat, longitude: curLon))
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}
