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

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var mapView: GMSMapView! = nil
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
        
        mapView.delegate = self
        mapView.myLocationEnabled = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Showing Map")
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(self.updateOnRequestsUpdatedNotification),
            name: Config.requestsUpdatedNotificationKey,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector:#selector(self.updateOnOffersUpdatedNotification),
            name: Config.offersUpdatedNotificationKey,
            object: nil)
        
        // Default is showing offer makers
        setOffers()
    }
    
    func clearMarkers() {
        self.mapView.clear()
        self.gMarkers = []
    }
    
    func setRequests() {
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
    
    func setOffers() {
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
        clearMarkers()
        switch segmentedControl!.selectedSegmentIndex {
        case 0:
            currentPage = segmentedControlPages.OffersMap
            setOffers()
            break;
        case 1:
            currentPage = segmentedControlPages.RequestsMap
            setRequests()
            break;
        default:
            break;
        }
    }
    
    func addMapMarkerToMap(marker: MapMarkerModel) {
        let gMarker = GMSMarker(position: marker.location)
        gMarker.title = marker.title
        gMarker.map = self.mapView
        gMarkers!.append(gMarker)
        print("Marker added \(gMarker.title) \(gMarker.position.latitude) | \(gMarker.position.longitude)")
    }
    
    func updateOnRequestsUpdatedNotification() {
        setRequests()
    }
    
    func updateOnOffersUpdatedNotification() {
        setOffers()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = mapView.myLocation {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }    
}
