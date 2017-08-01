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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string:"https://api.producthunt.com/v1/collections?sort_by=created_at&order=asc&access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff&search[category]=1&per_page=10")
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                                print(error ?? "")
                                return
                            }
                            do {
                                let json = JSON(data: data!);
                                let collections = json["collections"] as JSON
                                for(_, collectionJSON) in collections {
                                    let collection = Collection(json: collectionJSON)
                                    self.collections.append(collection)
                                }
                            } catch let jsonError {
                                print(jsonError)
                            }
            print(self.collections[1].title)
        }).resume()
        
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

