//
//  KeyChainHelper.swift
//  uph-mobile-ios
//
//  Created by Rifat Firdaus on 17/06/20.
//  Copyright © 2020 Suitmedia. All rights reserved.
//

import UIKit
import KeychainSwift

class KeyChainHelper: NSObject {

    static let instance = KeyChainHelper()
    
    internal var keyChain: KeychainSwift
    
    override init() {
        keyChain = KeychainSwift()
    }
    
    init(keyChain: KeychainSwift) {
        self.keyChain = keyChain
    }
    
    // MARK: VARIABLES
    
    var token: String? {
        get {
            return keyChain.get("token")
        }
        set(newValue) {
            if let newValue = newValue {
                keyChain.set(newValue, forKey: "token")
            } else {
                keyChain.delete("token")
            }
        }
    }
    
    var userId: String? {
        get {
            return keyChain.get("userId")
        }
        set(newValue) {
            if let newValue = newValue {
                keyChain.set(newValue, forKey: "userId")
            } else {
                keyChain.delete("userId")
            }
        }
    }
    
    // MARK: METHODS
    
    func clear() {
        keyChain.clear()
    }
}
