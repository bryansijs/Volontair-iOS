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
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    let regionRadius: CLLocationDistance = Config.defaultMapRadiusDistance
    let mapService = MapService.sharedInstance
    let locationManager = CLLocationManager()
    
    var gMarkers: [GMSMarker!]! = []
    
    enum segmentedControlPages : Int {
        case OffersMap = 0
        case RequestsMap = 1
    }
    var currentPage: segmentedControlPages = segmentedControlPages.OffersMap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
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
        
        // Default is showing offer makers
        setOfferMarkers()
        
        centerMapOnLocation(CLLocation(latitude: 51.692115, longitude: 5.177494))
    }
    
    func setRequestMarkers() {
        if currentPage != segmentedControlPages.RequestsMap {
            return
        }
        print("Set Request markers")
        clearMarkers()
        if let model = mapService.getMapViewModel() {
            if let requests = model.requests {
                for request in requests {
                    addMapMarkerToMap(request)
                }
            }
        }
    }
    
    func setOfferMarkers() {
        if currentPage != segmentedControlPages.OffersMap {
            return
        }
        print("Set Offer markers")
        clearMarkers()
        if let model = mapService.getMapViewModel() {
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
            currentPage = segmentedControlPages.OffersMap
            setOfferMarkers()
            break;
        case 1:
            currentPage = segmentedControlPages.RequestsMap
            setRequestMarkers()
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
        var gMarker = GMSMarker(position: marker.location)
        gMarker.title = marker.title
        gMarker.flat = true
        gMarker.map = self.mapView
        gMarkers!.append(gMarker)
        print("Marker added \(gMarker.title) \(gMarker.position.latitude) | \(gMarker.position.longitude)")
    }
    
    func clearMarkers() {
        for m in gMarkers {
            m.map = nil
        }
    }
    
    func updateOnRequestsUpdatedNotification() {
        setRequestMarkers()
    }
    
    func updateOnOffersUpdatedNotification() {
        setOfferMarkers()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}
