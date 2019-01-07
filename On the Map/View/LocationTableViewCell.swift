//
//  LocationTableViewCell.swift
//  On the Map
//
//  Created by Saud Alhelali on 06/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    
    var locationData: StudentInformation? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nameLabel.text = "\(locationData?.firstName ?? " ") \(locationData?.lastName ?? " ")"
        mediaURL.text = "\(locationData?.mediaURL ?? " ")"
    }

}
