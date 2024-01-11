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
    
    static func saveUserDefaults(id: Int = 0, nickname: String = "" , token: String = "", refresh: String = "") {
        UserDefaultsManager.isLogin = true
        UserDefaultsManager.id = id
        UserDefaultsManager.nickname = nickname
        UserDefaultsManager.token = token
        UserDefaultsManager.refresh = refresh
    }
    
    static func resetUserDefaults() {
        UserDefaultsManager.isLogin = false
        UserDefaultsManager.id = 0
        UserDefaultsManager.nickname = ""
        UserDefaultsManager.token = ""
        UserDefaultsManager.refresh = ""
    }
    
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
