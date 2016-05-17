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
        case VolunteersMap = 0
        case RequestsMap = 1
    }
    var currentPage: segmentedControlPages = segmentedControlPages.VolunteersMap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.setRequests), name: ApiConfig.requestDataUpdateNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.setVolunteers), name: ApiConfig.userOffersNotificationKey, object: nil)
        
        mapService.getRequests()
        mapService.getUsersInNeighbourhood()
    }
    
    override func viewDidAppear(animated: Bool) {
        setVolunteers()
    }
    
    func clearMarkers() {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
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
    
    func setVolunteers() {
        
        if currentPage != segmentedControlPages.VolunteersMap {
            return
        }
        print("Set UserOffer markers")
        // Clear all current markers from the map
        clearMarkers()
        // Iterate over all offers currently in the MapViewModel at MapService
        
        if let model = mapService.getMapViewModel() {
            if let offers = model.users {
                for userOffer in offers {
                    //userOffer.loadRoundPicutereAsync(nil, imageUrl: userOffer.imageUrl! , completionHandler: addMapMarkerToMap )
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
            currentPage = segmentedControlPages.VolunteersMap
            setVolunteers()
            break;
        case 1:
            currentPage = segmentedControlPages.RequestsMap
            setRequests()
            break;
        default:
            break;
        }
    }
    
    // Added given Marker to map
    func addMapMarkerToMap(marker: MapMarkerModel) -> Void{
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
    
        markerImage = UIImage(named: Config.defaultCategoryIconUrl)!

        if(annotation is UserMapModel) {
            if let markerAsUser = annotation as? MapMarkerModel {
                if let image = markerAsUser.image {
                    markerImage = self.getRoundedImage(image)
                }
            }
        } else if(annotation is RequestModel){
            if let markerAsUser = annotation as? MapMarkerModel {
                markerImage = self.getRoundedImage(markerAsUser.categorys![0].icon)
            }
        }
        
        annotationView!.image = markerImage
        
        return annotationView
    }
    
    func getRoundedImage(image : UIImage) -> UIImage {
        let imageLayer = CALayer()
        imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        imageLayer.contents = image.CGImage
        
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = image.size.width/2
        
        UIGraphicsBeginImageContext(image.size)
        
        imageLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let l = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}