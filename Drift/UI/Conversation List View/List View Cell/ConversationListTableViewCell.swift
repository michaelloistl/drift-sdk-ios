//
//  ConversationListTableViewCell.swift
//  Drift
//
//  Created by Brian McDonald on 26/07/2016.
//  Copyright © 2016 Drift. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = ColorPalette.darkPrimaryColor
        selectionStyle = .none
        messageLabel.textColor = ColorPalette.grayColor
        updatedAtLabel.textColor = ColorPalette.grayColor
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 3
        unreadCountLabel.clipsToBounds = true
        unreadCountLabel.layer.cornerRadius = 6
    }
}
