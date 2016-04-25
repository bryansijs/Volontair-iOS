//
//  MapViewController.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let mapService = MapService.sharedInstance
    let locationManager = CLLocationManager()
    
    enum segmentedControlPages : Int {
        case OffersMap = 0
        case RequestsMap = 1
    }
    var currentPage: segmentedControlPages = segmentedControlPages.OffersMap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
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
        // Clear markers from Map
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
    }
    
    func setRequests() {
        if currentPage != segmentedControlPages.RequestsMap {
            return
        }
        print("Set Request markers")
        // Clear all current markers from the map
        clearMarkers()
        // Iterate over all requests currently in the MapViewModel at MapService
        if let model = mapService.getMapViewModel() {
            if let requests = model.requests {
                for request in requests {
                    addMapMarkerToMap(request)
                }
            }
        }
    }
    
    func setOffers() {
        // Check if the call is legit
        if currentPage != segmentedControlPages.OffersMap {
            return
        }
        print("Set Offer markers")
        // Clear all current markers from the map
        clearMarkers()
        // Iterate over all offers currently in the MapViewModel at MapService
        if let model = mapService.getMapViewModel() {
            if let offers = model.offers {
                for offer in offers {
                    addMapMarkerToMap(offer)
                }
            }
        }
    }
    
    // IndexChanged for SegmentedControl
    @IBAction func indexChanged(sender: UISegmentedControl) {
        clearMarkers()
        switch segmentedControl!.selectedSegmentIndex {
        case 0:
            // Set currentPage enum to OffersMap
            currentPage = segmentedControlPages.OffersMap
            // Get and set Offers (Add to map)
            setOffers()
            break;
        case 1:
            // Set currentPage enum to RequestsMap
            currentPage = segmentedControlPages.RequestsMap
            // Get and set Requests (Add to map)
            setRequests()
            break;
        default:
            break;
        }
    }
    
    // Added given Marker to map
    func addMapMarkerToMap(marker: MapMarkerModel) {
        mapView?.addAnnotation(marker)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Not one of our custom Annotations
        if !(annotation is MapMarkerModel) {
            return nil
        }
        
        let reuseId = "reused_id"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
        } else {
          annotationView?.annotation = annotation
        }
        
        let mmm = annotation as! MapMarkerModel
        var markerImage: UIImage
        
        // Get iconUrl for specific
        //TODO: Replace "housekeeping" with mmm.category when chaging to API
        if let found = Config.categoryIconDictionary.indexOf({ $0.category == "default" }) {
            markerImage = UIImage(named: Config.categoryIconDictionary[found].iconUrl)!
        } else {
            // We couldn't find an icon for the given category, show the default
            markerImage = UIImage(named: Config.defaultCategoryIconUrl)!
        }
        
        // Resize icon (outcomment if required)
        //UIGraphicsBeginImageContext(Config.defaultMapAnnotationImageSize)
        //markerImage.drawInRect(CGRectMake(0, 0, Config.defaultMapAnnotationImageSize.width, Config.defaultMapAnnotationImageSize.height))
        //let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        //UIGraphicsEndImageContext()
        
        // Change markerImage to resizedImage if resizing
        annotationView!.image = markerImage
        
        return annotationView
    }
    
    func updateOnRequestsUpdatedNotification() {
        setRequests()
    }
    
    func updateOnOffersUpdatedNotification() {
        setOffers()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            // Start updating location when authorized
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Set region on map once by user location and stop updating
            let l = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            // Todo: bind Span to radius set by user?
            let span = MKCoordinateSpanMake(Config.defaultMapLatitudeDelta, Config.defaultMapLongitudeDelta)
            let region = MKCoordinateRegion(center: l, span: span)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}