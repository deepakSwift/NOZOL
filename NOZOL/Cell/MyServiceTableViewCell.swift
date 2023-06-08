//
//  MyServiceTableViewCell.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import GMStepper

class MyServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var labelServiceName : UILabel!
    @IBOutlet weak var labelPrice : UILabel!
    @IBOutlet weak var labelDescription : UILabel!
    @IBOutlet weak var imageViewService : UIImageView!
    @IBOutlet weak var labelQuantity : UILabel!
    @IBOutlet weak var addStepperView: GMStepper!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var labelServiceStatus : UILabel!
    @IBOutlet weak var labelPriceTag : UILabel!
    @IBOutlet weak var labelQuantityTag : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
