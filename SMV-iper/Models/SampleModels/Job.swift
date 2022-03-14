//
//  Job.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on August 6, 2018

import Foundation
import SwiftyJSON
import RealmSwift

final class Job: Object, Parseable {
    
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var descriptionField: String?
    @objc dynamic var name: String?
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(realm: Realm, json: JSON) -> Job? {
        let identifier = json["id"].int64Value
        if identifier == 0 {
            return nil
        }
        var obj = realm.object(ofType: Job.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = Job()
            obj?.identifier = identifier
        } else {
            obj = Job(value: obj!)
        }
        
        if json["description"].exists() {
            obj?.descriptionField = json["description"].string
        }
        
        if json["name"].exists() {
            obj?.name = json["name"].string
        }
        
        return obj
    }
    
    public static func with(json: JSON) -> Job? {
        return with(realm: try! Realm(), json: json)
    }
    
    static func fromJson(_ json: JSON) -> Job? {
        return with(json: json)
    }
    
}
