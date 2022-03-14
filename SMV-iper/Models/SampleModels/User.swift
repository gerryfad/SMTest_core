//
//  User.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class User: Object, Parseable {
    @objc dynamic var identifier: Int = 0
    @objc dynamic var email: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var avatar: String?
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(realm: Realm, json: JSON) -> User? {
        let identifier = json["id"].intValue
        if identifier == 0 {
            return nil
        }
        var obj = realm.object(ofType: User.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = User()
            obj?.identifier = identifier
        } else {
            obj = User(value: obj!)
        }
        
        if json["email"].exists() {
            obj?.email = json["email"].string
        }
        
        if json["first_name"].exists() {
            obj?.firstName = json["first_name"].string
        }
        
        if json["last_name"].exists() {
            obj?.lastName = json["last_name"].string
        }
        
        if json["avatar"].exists() {
            obj?.avatar = json["avatar"].string
        }
        
        return obj
    }
    
    public static func with(json: JSON) -> User? {
        return with(realm: try! Realm(), json: json)
    }
    
    static func fromJson(_ json: JSON) -> User? {
        return with(json: json)
    }
}

