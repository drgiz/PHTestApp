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
    
    var collections = [Collection]()
    let applicationManager = ApplicationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
    }
    
    func fetchFeed() {
        applicationManager.getCollectionsFeed { response in
            switch response.result {
            case .success( _):
                let responseJSON = JSON(response.data!)
                let collectionsJSON = responseJSON["collections"] as JSON
                for (_,collectionJSON) in collectionsJSON {
                    let collection = Collection(json: collectionJSON)
                    self.collections.append(collection)
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
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if collections.count>0
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
        return self.collections.count
    }
}

