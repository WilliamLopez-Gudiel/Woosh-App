//
//  logCell.swift
//  workoutApp
//
//  Created by William Gudiel on 8/23/20.
//  Copyright © 2020 William. All rights reserved.
//

import UIKit

class logCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
