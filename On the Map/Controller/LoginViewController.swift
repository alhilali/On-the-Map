//
//  ViewController.swift
//  On the Map
//
//  Created by Saud Alhelali on 05/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginClicked(_ sender: Any) {
        if (emailTextField.text! == "" || passwordTextField.text! == "") {
            self.displayAlert(title: "Error", message: "Please provide email and password to login")
        } else {
            Network.postSession(email: emailTextField.text!, password: passwordTextField.text!) { (errString) in
                guard errString == nil else {
                    self.displayAlert(title: "Error", message: errString!)
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoggedIn", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

