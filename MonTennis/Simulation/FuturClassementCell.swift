//
//  FuturClassementCell.swift
//  MonTennis
//
//  Created by Thomas Luquet on 02/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class FuturClassementCell: UITableViewCell {
    @IBOutlet weak var futurClassement: UILabel!
    @IBOutlet weak var bilan1Label: UILabel!
    @IBOutlet weak var bilan2Label: UILabel!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
