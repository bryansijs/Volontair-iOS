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
    var selectedRequest : RequestModel?
    var selectedUser: UserModel?
    
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
    
    //click on marker
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MapMarkerModel {
            
            if(currentPage == segmentedControlPages.VolunteersMap){
                //profile
                let userProfile = annotation as! UserMapModel
                self.selectedUser = userProfile.owner
                self.performSegueWithIdentifier("showUserProfile", sender: self)
                
            } else {
                //request list or item
                if let requestAnnotation = annotation as? RequestModel{
                    if (requestAnnotation.owner?.requests?.count > 1){
                        //list
                        self.performSegueWithIdentifier("showUserRequests", sender: self)
                    }
                    else{
                        //item
                        self.selectedRequest = requestAnnotation
                        self.performSegueWithIdentifier("showUserOnlyRequest", sender: self)
                    }
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showUserRequests") {
            // pass data to List
            let newController = segue.destinationViewController as! UserRequestTableViewController
            newController.requests = (selectedRequest?.owner?.requests)!
            newController.editMode = false
        }
        if (segue.identifier == "showUserOnlyRequest") {
            // pass data to UserRequestDetailViewController
            let newController = segue.destinationViewController as! UserRequestDetailViewController
            newController.detailItem = selectedRequest
            newController.editMode = false
        }
        if (segue.identifier == "showUserProfile") {
            // pass data to Profile Page
            let newController = segue.destinationViewController as! ProfileViewController
            newController.user = self.selectedUser
            newController.editMode = false
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
            detailButton.frame.size.width = 30
            detailButton.frame.size.height = 30
            //detailButton.backgroundColor = UIColor.grayColor()
            detailButton.setBackgroundImage(UIImage(named: "blueArrow"), forState: .Normal)
            //detailButton.setImage(UIImage(named: "test"), forState: .Normal)
            
            
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
                    markerImage = getRoundedImage(image, backgroundColorHex: nil)
                }
            }
        } else if(annotation is RequestModel) {
            if let markerAsUser = annotation as? MapMarkerModel {
                markerImage = getRoundedImage(markerAsUser.categorys![0].icon, backgroundColorHex: markerAsUser.categorys![0].colorHex)
            }
        }
            
        annotationView!.image = markerImage
        
        return annotationView
    }
    
    func getRoundedImage(image : UIImage, backgroundColorHex : String?) -> UIImage {
        
        let imageHeight = CGFloat(ApiConfig.mapIconDiameter)
        let imageWidth = CGFloat(ApiConfig.mapIconDiameter)
        
        let imageLayer = CALayer()
        imageLayer.frame = CGRectMake(0, 0, imageWidth, imageHeight)
        
        imageLayer.contentsScale = CGFloat(2)
        imageLayer.contents = image.CGImage
        
        let borderWhite = UIColor.whiteColor()
        imageLayer.borderWidth = CGFloat(2)
        imageLayer.borderColor = borderWhite.CGColor
        
        if let backColor = backgroundColorHex {
            imageLayer.backgroundColor = hexStringToUIColor(backColor).CGColor
        }
        
        
        
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = imageWidth/2
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        UIGraphicsBeginImageContext(size)
        
        imageLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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