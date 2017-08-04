//
//  PostDetailController.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 04.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import UIKit
import SDWebImage

class PostDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postScreenshot: UIImageView!
    
    let postDetailCellIdentifier = "PostDetailTableViewCell"
    var post:Post?
    
    override func viewDidLoad() {
        title = post?.name
        
        
        if let post = post {
            if post.screenshot_url_350px != "" {
                postScreenshot.sd_setImage(with: URL(string: post.screenshot_url_350px))
            } else if post.screenshot_url_850px != "" {
                postScreenshot.sd_setImage(with: URL(string: post.screenshot_url_850px))
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postDetailCellIdentifier, for: indexPath)
        if let cell = cell as? PostDetailTableViewCell {
            switch indexPath.row {
            case 0:
                cell.fieldLabel.text = "Name"
                cell.valueLabel.text = post?.name
            case 1:
                cell.fieldLabel.text = "Tagline"
                cell.valueLabel.text = post?.tagline
            case 2:
                cell.fieldLabel.text = "Upvotes"
                cell.valueLabel.text = String(describing: post?.votes_count)
            case 3:
                cell.fieldLabel.text = "URL"
                cell.valueLabel.text = post?.redirect_url
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
        }
        return cell

    }
    
}
