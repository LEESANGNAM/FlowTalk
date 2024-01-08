//
//  UserDefaultsManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/8/24.
//

import Foundation
struct UserDefaultsManager {
    @UserDefaultsWrapper(key: "isLogin", defaultValue: false)
    static var isLogin
    @UserDefaultsWrapper(key: "token", defaultValue: "")
    static var token
    @UserDefaultsWrapper(key: "refreshToken", defaultValue: "")
    static var refresh
    @UserDefaultsWrapper(key: "id", defaultValue: 0)
    static var id
    @UserDefaultsWrapper(key: "nickname", defaultValue: "")
    static var nickname
}

@propertyWrapper
private struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
