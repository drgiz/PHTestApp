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
    
    let categories = ["Tech","Games","Podcasts","Books"]
    
    var updateInProgress = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        let nib = UINib (nibName: postCellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: postCellIdentifier)
        
        // MARK: - Setup pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchFeedFromInternet), for: .valueChanged)
        
        fetchFeedFromLocalStorage()
        fetchFeed()
    }
    
    func fetchFeedFromLocalStorage() {
        posts = applicationManager.loadPosts()
        tableView.reloadData()
    }
    
    func fetchFeedFromInternet() {
        if !updateInProgress {
            updateInProgress = true
            fetchFeed()
        }
    }
    
    func fetchFeed() {
        var navigationTitle = String()
        if let title = self.navigationItem.title {
            navigationTitle = title
        } else {
            navigationTitle = categories[0]
        }
        applicationManager.getPostsFeed(withCategory: navigationTitle.lowercased(), response: { response in
            switch response.result {
            case .success( _):
                self.posts = [Post]()
                // MARK: - Populate posts upon success
                let responseJSON = JSON(response.data!)
                let postsJSON = responseJSON["posts"] as JSON
                for (_,postJSON) in postsJSON {
                    let post = Post(json: postJSON)
                    self.posts.append(post)
                }
                self.applicationManager.savePosts(posts: self.posts)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async(execute: {
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            })
            self.updateInProgress = false
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
    
    //MARK: - Placeholder for blank table
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
            noDataLabel.text = "No posts to display :("
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
                if let url = URL(string:posts[indexPath.row].screenshot_url_350px) {
                    SDWebImagePrefetcher.shared().prefetchURLs([url])
                }
                destinationController.post = posts[indexPath.row]
            }
        }
    }
    
    //MARK: - Category button tap responder & UIPicker Methods
    
    @IBAction func tapCategoriesButton(_ sender: Any) {
        
        //Check if view with tag9 already exists
        if (self.view.viewWithTag(9) != nil) {
            return
        }
        
        //MARK: - Configure blurry background
        self.navigationController?.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 9
        blurEffectView.frame = (self.navigationController?.view.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCategoryPicker))
        blurEffectView.addGestureRecognizer(tapGesture)
        self.navigationController?.view.addSubview(blurEffectView)
        
        //MARK: - Configure UIPicker
        let categoryPicker = UIPickerView(frame: CGRect(x:0, y:0, width:(self.navigationController?.view.bounds.width)!, height:300))
        categoryPicker.tag = 10;
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        if let title = self.navigationItem.title {
            if let index = categories.index(of: title) {
                categoryPicker.selectRow(index, inComponent: 0, animated: false)
            } else {
                categoryPicker.selectRow(0, inComponent: 0, animated: false)
            }
        }
        categoryPicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationController?.view.addSubview(categoryPicker)
        
        //MARK: - Configure TooolBar
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:(self.navigationController?.view.bounds.width)!, height:64))
        toolbar.tag = 11
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toolbar.barStyle = UIBarStyle.blackTranslucent
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissCategoryPicker))
        doneButton.tintColor = .white
        toolbar.setItems([spacer,doneButton], animated: true)
        self.navigationController?.view.addSubview(toolbar)
        
    }
    
    func dismissCategoryPicker() {
        removeViews()
        fetchFeedFromInternet()
    }
    
    func removeViews() {
        self.navigationController?.view.viewWithTag(9)?.removeFromSuperview()
        self.navigationController?.view.viewWithTag(10)?.removeFromSuperview()
        self.navigationController?.view.viewWithTag(11)?.removeFromSuperview()
    }
    
}

//MARK: - Table view Image Prefetching
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

//MARK: - UIPickerView delegate & data source
extension FeedController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categories[row]
        self.navigationItem.title = selectedCategory
    }
    //MARK: - UIPickerView customization
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 24)
        label.text = categories[row]
        return label
    }
}

