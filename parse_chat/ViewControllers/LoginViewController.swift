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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
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
            if let error = error {
                self.alertController.message = "Sign up failed: \(error.localizedDescription)"
                self.present(self.alertController, animated: true) {}
            } else {
                print("Yay created a user!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                self.alertController.message = "Log in failed: \(error.localizedDescription)"
                self.present(self.alertController, animated: true) {}
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
