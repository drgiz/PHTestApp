//
//  CollectionCell.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 02.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {
    
    @IBOutlet weak var cellThumbnail: UIImageView!

    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    @IBOutlet weak var cellUpvotes: UILabel!
}

