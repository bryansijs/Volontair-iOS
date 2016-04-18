//
//  DiscoverItemTableViewCell.swift
//  Volontair
//
//  Created by M Mommersteeg on 18/04/16.
//  Copyright © 2016 Volontair. All rights reserved.
//

import UIKit

class DiscoverItemTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
