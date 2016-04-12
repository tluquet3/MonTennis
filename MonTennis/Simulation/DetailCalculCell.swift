//
//  DetailCalculCell.swift
//  MonTennis
//
//  Created by Thomas Luquet on 23/06/2015.
//  Copyright (c) 2015 Thomas Luquet. All rights reserved.
//

import UIKit

class DetailCalculCell: UITableViewCell {

    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var resultat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
