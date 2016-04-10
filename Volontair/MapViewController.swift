//
//  MapViewController.swift
//  Volontair
//
//  Created by M Mommersteeg on 10/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView?
    
    let regionRadius: CLLocationDistance = 500
    let mapService = MapService.sharedInstance
    
    var markers: [MapMarkerModel] = []
    
    override func viewDidAppear(animated: Bool) {
        print("Showing Map")
        
        updateMarkers()
    }
    
    func updateMarkers() {
        if let data = mapService.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func addMapMarkerToMap(marker: MapMarkerModel) {
        mapView?.addAnnotation(marker)
    }
}
