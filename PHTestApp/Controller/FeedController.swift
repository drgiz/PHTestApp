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
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
    }
    
    func fetchFeed() {
        guard let url = URL(string: "https://api.producthunt.com/v1/collections?sort_by=created_at&order=asc&access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff&search[category]=1&per_page=10") else { return }
        
        NetworkManager.request(url: url) { response in
            switch response.result {
            case .success( _):
                let responseJSON = JSON(response.data!)
                let collectionsJSON = responseJSON["collections"] as JSON
                    for (_,collectionJSON) in collectionsJSON {
                        let collection = Collection(json: collectionJSON)
                        self.collections.append(collection)
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


}

