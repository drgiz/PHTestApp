//
//  ViewController.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 01.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class FeedController: UITableViewController {
    
    var posts = [Post]()
    let applicationManager = ApplicationManager.shared
    let postCellIdentifier = "PostCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let nib = UINib (nibName: postCellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: postCellIdentifier)
        
        // MARK: - Setup pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchFeedFromInternet), for: .valueChanged)
        
        fetchFeed()
    }
    
    func fetchFeedFromInternet() {
        fetchFeed()
    }
    
    func fetchFeed() {
        applicationManager.getPostsFeed(withCategory: Category.Tech, numberOfPosts: 10, response: { response in
            switch response.result {
            case .success( _):
                self.posts = [Post]()
                // MARK: - Populate posts upon success
                let responseJSON = JSON(response.data!)
                let postsJSON = responseJSON["posts"] as JSON
                for (_,postJSON) in postsJSON {
                    let post = Post(json: postJSON)
                    self.posts.append(post)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                    if let refreshControl = self.refreshControl {
                        if refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
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
            cell.upvotes.text = "👍"+String(posts[indexPath.row].votes_count)
            cell.thumbnail.sd_setShowActivityIndicatorView(true)
            cell.thumbnail.sd_setIndicatorStyle(.gray)
            cell.thumbnail.sd_setImage(with: URL(string:posts[indexPath.row].thumbnail_url),
                                       placeholderImage: nil,
                                       options: [.retryFailed, .scaleDownLargeImages],
                                       completed: { (_, error, _, _) in
                                        guard error != nil else {return}
                                        cell.thumbnail.sd_removeActivityIndicator() })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    //MARK: - Placeholder for initial screen
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

    //MARK: - Tap on cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPostDetail", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! PostDetailController
                destinationController.post = posts[indexPath.row]
            }
        }
    }
    
}

//MARK: - Image Prefetching
extension FeedController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var urls:[URL]?
        for indexPath in indexPaths {
            if let url = URL(string:posts[indexPath.row].thumbnail_url) {
                urls?.append(url)
            }
        }
        SDWebImagePrefetcher.shared().prefetchURLs(urls)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        SDWebImagePrefetcher.shared().cancelPrefetching()
    }
}

