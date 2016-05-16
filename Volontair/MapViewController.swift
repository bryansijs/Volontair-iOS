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


    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.setRequests), name: ApiConfig.requestsUpdatedNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.setUserOffers), name: ApiConfig.userOffersNotificationKey, object: nil)
        
        mapService.getRequests()
        mapService.getUsersInNeighbourhood()
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
        setUserOffers()
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
    
    func setUserOffers() {
        
        if currentPage != segmentedControlPages.OffersMap {
            return
        }
        print("Set UserOffer markers")
        // Clear all current markers from the map
        clearMarkers()
        // Iterate over all offers currently in the MapViewModel at MapService
        
        if let model = mapService.getMapViewModel() {
            if let offers = model.users {
                for userOffer in offers {
                    addMapMarkerToMap(userOffer)
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
            setUserOffers()
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MapMarkerModel {
            
            print("\(annotation.title) tapped")
            
            self.performSegueWithIdentifier("showUserRequests", sender: self)
            //mapView.removeAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Not one of our custom Annotations
        if !(annotation is MapMarkerModel) {
            return nil
        }
        
        let reuseId = "reused_id"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if annotationView == nil {
            
            // detail button
            let detailButton = UIButton(type: UIButtonType.System)
            detailButton.frame.size.width = 44
            detailButton.frame.size.height = 44
            detailButton.backgroundColor = UIColor.redColor()
            detailButton.setImage(UIImage(named: "trash"), forState: .Normal)
            
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = detailButton
            //annotationView?.leftCalloutAccessoryView = detailButton

        } else {
          annotationView?.annotation = annotation
        }
        
        let mmm = annotation as! MapMarkerModel
        var markerImage: UIImage
        
        // Get iconUrl for specific
        if let found = Config.categoryIconDictionary.indexOf({ $0.category == mmm.category }) {
            markerImage = UIImage(named: Config.categoryIconDictionary[found].iconUrl)!
        } else {
            // We couldn't find an icon for the given category, show the default
            markerImage = UIImage(named: Config.defaultCategoryIconUrl)!
        }
        
//        // Resize icon (outcomment if required)
//        UIGraphicsBeginImageContext(Config.defaultMapAnnotationImageSize)
//        markerImage.drawInRect(CGRectMake(0, 0, Config.defaultMapAnnotationImageSize.width, Config.defaultMapAnnotationImageSize.height))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        // Change markerImage to resizedImage if resizing
        annotationView!.image = markerImage
        
        return annotationView
    }
    
    func updateOnRequestsUpdatedNotification() {
        setRequests()
    }
    
    func updateOnOffersUpdatedNotification() {
        setUserOffers()
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
        }
    }
}