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
    var mapView: GMSMapView! = nil
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
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
        setOfferMarkers()
    }
    
    func setRequestMarkers() {
        if currentPage != segmentedControlPages.RequestsMap {
            return
        }
        print("Set Request markers")
        self.mapView.clear()
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
        self.mapView.clear()
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
    
    func addMapMarkerToMap(marker: MapMarkerModel) {
        let gMarker = GMSMarker(position: marker.location)
        gMarker.title = marker.title
        gMarker.map = self.mapView
        gMarkers!.append(gMarker)
        print("Marker added \(gMarker.title) \(gMarker.position.latitude) | \(gMarker.position.longitude)")
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
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 6, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}
