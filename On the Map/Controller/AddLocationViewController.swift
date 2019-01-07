//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 06/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBAction func findLocationClicked(_ sender: Any) {
        guard let location = locationTextField.text,
            let link = linkTextField.text,
            location != "", link != "" else {
                self.displayAlert(title: "Error", message: "Location field and link field are mandetory")
                return
        }
        
        let studentLocation = StudentInformation(mapString: location, mediaURL: link)
        geocodeCoordinates(studentLocation)
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentInformation) {
        
        let spinner = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            spinner.stopAnimating()

            guard let firstLocation = placeMarks?.first?.location else {
                self.displayAlert(title: "Error", message: "Couldn't find location")
                return
            }

            var location = studentLocation
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude

            self.performSegue(withIdentifier: "viewLocation", sender: location)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewLocation", let vc = segue.destination as? LocationDetailsViewController {
            vc.location = (sender as! StudentInformation)
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Spinnet method
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(spinner)
        self.view.bringSubviewToFront(spinner)
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }

}
