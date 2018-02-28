//
//  ChatViewController.swift
//  parse_chat
//
//  Created by Nancy Gomez on 2/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
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
    
    @objc func onTimer() {
        print("ONE")
        getMessages()
    }
    
    func getMessages() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages{
                // do something with the array of object returned by the call
                for message in messages {
                    // access the object as a dictionary and cast type
                    print(message)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
