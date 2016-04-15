//
//  MapViewController.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import CoreLocation

import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView?
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    let regionRadius: CLLocationDistance = Config.defaultMapRadiusDistance
    let mapService = MapService.sharedInstance
    let locationManager = CLLocationManager()
    
    var markers: [MapMarkerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use GPS in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
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
        
        centerMapOnLocation(CLLocation(latitude: 51.692115, longitude: 5.177494))
    }
    
    func updateMarkers() {
        print("Set requests and offers")
        if let model = mapService.getMapViewModel() {
            if let requests = model.requests {
                for request in requests {
                    print(request)
                    addMapMarkerToMap(request)
                }
            }
            if let offers = model.offers {
                for offer in offers {
                    addMapMarkerToMap(offer)
                }
            }
        }
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl!.selectedSegmentIndex {
        case 0:
            break;
        case 1:
            break;
        default:
            break;
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        print("Centering Map Location")
        let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.mapView = mapView
    }
    
    func addMapMarkerToMap(marker: MapMarkerModel) {
        let gMarker = GMSMarker(position: marker.location)
        gMarker.title = marker.title
        gMarker.map = self.mapView
        print("Marker added")
        print(gMarker.title, marker.location)
    }
    
    func updateOnRequestsUpdatedNotification() {
        updateMarkers()
    }
    
    func updateOnOffersUpdatedNotification() {
        updateMarkers()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            centerMapOnLocation(CLLocation(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            )
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("LocationManager failed to retrieve position")
        print(error)
    }
}
