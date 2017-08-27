//
//  DinersDetailTableViewCell.swift
//  Diners
//
//  Created by Александра Гольде on 28/01/2017.
//  Copyright © 2017 Александра Гольде. All rights reserved.
//

import UIKit

class DinersDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
