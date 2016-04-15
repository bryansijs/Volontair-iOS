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

import GoogleMaps

class MapViewController: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView?
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
        let camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        marker.title = "TitleText"
        marker.snippet = "SnippetText"
        marker.map = mapView        
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
