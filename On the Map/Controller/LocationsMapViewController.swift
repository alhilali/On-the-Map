//
//  LocationsMapViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 06/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapViewController: ContentViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    private var reusePinID = "pin"

    override var locationsData: LocationsData? {
        didSet {
            loadLocations()
        }
    }
    
    func loadLocations() {
        guard let locations = locationsData?.studentLocations else { return }
        
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePinID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .orange
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let link = view.annotation?.subtitle!,
                let url = URL(string: link), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            } else {
                displayAlert(title: "Error", message: "Link couldn't be opened")
            }
        }
    }

}
