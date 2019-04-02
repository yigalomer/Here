//
//  TaxiTableViewCell.swift
//  Here_Assignment
//
//  Created by Yigal Omer on 02/04/2019.
//  Copyright © 2019 Yigal Omer. All rights reserved.
//

import UIKit

class TaxiTableViewCell: UITableViewCell {

    @IBOutlet weak var taxiLogoImage: UIImageView!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var ETA: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
