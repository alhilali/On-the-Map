//
//  UIViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 05/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
