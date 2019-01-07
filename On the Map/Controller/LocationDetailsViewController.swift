//
//  LocationDetailsViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 06/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    var location: StudentInformation?
    
    private var reusePinID = "pin"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMap()
    }
    
    private func initMap() {
        print(location ?? "null")
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()

        annotation.coordinate = coordinate
        annotation.title = location.mapString

        map.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePinID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
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
                displayAlert(title: "Error", message: "Couldn't open URL")
            }
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        Network.postLocation(self.location!) { err  in
            guard err == nil else {
                self.displayAlert(title: "Error", message: err!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
