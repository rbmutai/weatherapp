//
//  ForcastCell.swift
//  Conditions
//
//  Created by MAC USER on 10/06/2021.
//

import UIKit

class ForcastCell: UITableViewCell {

    @IBOutlet weak var lbtemp: UILabel!
    @IBOutlet weak var imweather: UIImageView!
    @IBOutlet weak var lbdayofweek: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
