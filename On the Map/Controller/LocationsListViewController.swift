//
//  LocationsListViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 06/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit

class LocationsListViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationsTable: UITableView!
    
    override var locationsData: LocationsData? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.studentLocations
        }
    }
    var locations: [StudentInformation] = [] {
        didSet {
            locationsTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        cell.locationData = locations[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mediaURL = locations[indexPath.row].mediaURL,
            let url = URL(string: mediaURL),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            displayAlert(title: "Error", message: "Link couldn't be opened")
        }
    }

}
