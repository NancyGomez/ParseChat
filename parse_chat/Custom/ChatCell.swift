//
//  ChatCell.swift
//  parse_chat
//
//  Created by Nancy Gomez on 2/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    let alertController = UIAlertController(title: "Error", message: "Message", preferredStyle: .alert)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
