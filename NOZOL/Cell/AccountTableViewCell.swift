//
//  AccountTableViewCell.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture : UIImageView!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var emailLabel : UILabel!
     @IBOutlet weak var labelRoomNo : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}





class AccountSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var checkInImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
