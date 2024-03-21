//
//  BaseStorage.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/21/24.
//

import Foundation

import RealmSwift

class BaseStorage {
    let realm: Realm
    
    init?() {
        guard let realm = try? Realm() else { return nil }
        self.realm = realm
        
        if let fileURL = realm.configuration.fileURL {
            print("램 위치 fileURL: ",fileURL)
        }
    }
}
