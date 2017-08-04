//
//  PostDetailTableViewCell.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 04.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldLabel: UILabel!
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
