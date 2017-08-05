//
//  PostDetailController.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 04.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class PostDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postScreenshot: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getItButton: UIButton!
    
    let postDetailCellIdentifier = "PostDetailTableViewCell"
    var post:Post?
    var redirectUrl: URL?
    
    override func viewDidLoad() {
        
        //MARK: - Dynamic cell height
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //MARK: - Get it button setup
        getItButton.backgroundColor = UIColor.productHuntOrange
        if let font = UIFont(name: "Helvetica", size: 24.0) {
            getItButton.setAttributedTitle(NSAttributedString(string: "Get it!", attributes:
                [NSForegroundColorAttributeName: UIColor.white,
                 NSFontAttributeName: font]),
                                           for: .normal)
        }
        
        if let post = post {
            title = post.name
            if post.screenshot_url_350px != "" {
                postScreenshot.sd_setImage(with: URL(string: post.screenshot_url_350px))
            } else if post.screenshot_url_850px != "" {
                postScreenshot.sd_setImage(with: URL(string: post.screenshot_url_850px))
            }
            if let url = URL(string:post.redirect_url) {
                getItButton.isEnabled = true
                redirectUrl = url
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //MARK: - Populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postDetailCellIdentifier, for: indexPath)
        if let cell = cell as? PostDetailTableViewCell, let post = post {
            switch indexPath.row {
            case 0:
                cell.fieldLabel.text = "Name"
                cell.valueLabel.text = post.name
            case 1:
                cell.fieldLabel.text = "Tagline"
                cell.valueLabel.text = post.tagline
            case 2:
                cell.fieldLabel.text = "Upvotes"
                cell.valueLabel.text = String(post.votes_count)
            case 3:
                cell.fieldLabel.text = "URL"
                cell.valueLabel.text = post.redirect_url
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
        }
        return cell
    }
    //MARK: - External URL in SFSafariVC
    @IBAction func getItButtonTap(_ sender: Any) {
        if let url = redirectUrl {
            let safariController = SFSafariViewController(url: url)
            UIApplication.shared.statusBarStyle = .default
            present(safariController, animated: true, completion: nil)
        }
    }
    
}
