//
//  WeatherDayTableViewCell.swift
//  Assignment_2
//
//  Created by Student on 2019-12-05.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class WeatherDayTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var lblDayOfWeek: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
