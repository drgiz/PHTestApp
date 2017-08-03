//
//  ViewController.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 01.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import UIKit
import SwiftyJSON


class FeedController: UITableViewController {
    
    var posts = [Post]()
    let applicationManager = ApplicationManager.shared
    let postCellIdentifier = "PostCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib (nibName: postCellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: postCellIdentifier)
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchFeed()
    }
    
    func fetchFeed() {
        applicationManager.getCollectionsFeed { response in
            switch response.result {
            case .success( _):
                let responseJSON = JSON(response.data!)
                let postsJSON = responseJSON["posts"] as JSON
                for (_,postJSON) in postsJSON {
                    let post = Post(json: postJSON)
                    self.posts.append(post)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier, for: indexPath)
        if let cell = cell as? PostCell {
            cell.name.text = posts[indexPath.row].name
            cell.tagline.text = posts[indexPath.row].tagline
            cell.upvotes.text = String(posts[indexPath.row].votes_count)
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if posts.count>0
        {
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = .zero
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: tableView.bounds.size.width,
                                                             height: tableView.bounds.size.height))
            noDataLabel.text = "No data to display :("
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
}

