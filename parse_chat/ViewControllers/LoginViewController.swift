//
//  LoginViewController.swift
//  parse_chat
//
//  Created by Nancy Gomez on 2/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create an OK action and add to alert
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(OKAction)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        // check to make sure fields aren't empty
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.alertController.message = "Sign up failed: username or password empty."
            self.present(self.alertController, animated: true) {}
            return
        }
        
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
    
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            self.activityIndicator.startAnimating()
            if let error = error {
                self.alertController.message = "Sign up failed: \(error.localizedDescription)"
                self.present(self.alertController, animated: true) {}
                self.activityIndicator.stopAnimating()
            } else {
                print("Yay created a user!")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        self.activityIndicator.startAnimating()
        
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                self.alertController.message = "Log in failed: \(error.localizedDescription)"
                self.present(self.alertController, animated: true) {}
                self.activityIndicator.stopAnimating()
            } else {
                print("User logged in successfully")
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
