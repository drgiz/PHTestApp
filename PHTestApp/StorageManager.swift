//
//  StorageManager.swift
//  PHTestApp
//
//  Created by Svyatoslav Bykov on 17.08.17.
//  Copyright © 2017 Svyatoslav Bykov. All rights reserved.
//

import Foundation

class StorageManager {
    func saveDataForKey(value: Any, key:String) -> Void {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func loadDataForKey(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}


