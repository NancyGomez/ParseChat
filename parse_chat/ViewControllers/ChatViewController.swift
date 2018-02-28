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
//    var chatMessages: [ChatMessage] = []
    
    var messages: [String] = []
    var usernames: [String] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50

        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)
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
    
    @objc func getMessages() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages{
                if(messages != nil){
                    self.messages = []
                    
                    for message in messages{
                        // First check if a message exists
                        if message["text"] != nil {
                            print(message["text"])
                            self.messages.append(message["text"] as! String)
                            
                            // First check if a user exists
                            if message["user"] != nil {
                                let user = message["user"] as! PFUser
                                self.usernames.append(user.username!)
                            } else {
                                // No user found, set default username
                                self.usernames.append("🤖")
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                else{
                    print("Info:! \(error?.localizedDescription)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.messageTextLabel.text = self.messages[indexPath.row]
        cell.usernameTextLabel.text = self.usernames[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
