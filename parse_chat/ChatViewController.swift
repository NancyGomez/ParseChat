//
//  ChatViewController.swift
//  parse_chat
//
//  Created by Nancy Gomez on 2/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageTextField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            } else {
                print("The message was saved!")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
