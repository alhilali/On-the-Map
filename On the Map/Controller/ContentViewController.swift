//
//  ContentViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 06/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var locationsData: LocationsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // To keep locations up to date
        // I called it in viewWillAppear
        loadStudentLocations()
    }
    
    func setupUI() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationClicked(_:)))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutTapped(_:)))
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func addLocationClicked(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocation") as! UINavigationController
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func logoutTapped(_ sender: Any) {
        // Here you should call the corresponding API for deleting the session, and you should go back to Login screen on success
        Network.deleteSession() { err  in
            guard err == nil else {
                self.displayAlert(title: "Error", message: err!)
                return
            }
            
            let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
            
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    private func loadStudentLocations() {
        Network.getStudentInformationList { (data) in
            guard let data = data else {
                self.displayAlert(title: "Error", message: "An error occured while reading locations")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.displayAlert(title: "Error", message: "No location found")
                return
            }
            self.locationsData = data
        }
    }

}
