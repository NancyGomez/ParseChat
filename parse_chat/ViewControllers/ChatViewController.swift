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
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)
    var refreshControl: UIRefreshControl!
    
//    var chatMessages: [ChatMessage] = []
    
    var messages: [String] = []
    var usernames: [String] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(OKAction)

        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)
    }
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        let user = PFUser.current()
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage["user"] = user
        
        if (messageTextField.text == "") {
            self.alertController.message = "Error, empty message."
            self.present(self.alertController, animated: true) {}
            return
        }
        chatMessage.saveInBackground { (success, error) in
            if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            } else {
                print("The message was saved!")
                self.messageTextField.text = ""
            }
        }
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        getMessages()
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
                    self.usernames = []
                    for message in messages{
                        // First check if a message exists
                        if message["text"] != nil {
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
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.messageTextLabel.text = self.messages[indexPath.row]
        cell.usernameTextLabel.text = self.usernames[indexPath.row]
        
        cell.bubbleView.layer.cornerRadius = 16
        cell.bubbleView.clipsToBounds = true
        
        return cell
        
    }
    @IBAction func onLogOut(_ sender: Any) {
        print("Log Out Pressed")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
