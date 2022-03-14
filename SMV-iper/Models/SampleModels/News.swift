//
//  News.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on October 3, 2018

import Foundation
import SwiftyJSON
import RealmSwift

final class News: Object, Parseable {
    
    @objc dynamic var identifier: Int = 0
    @objc dynamic var title: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    public static func with(realm: Realm, json: JSON) -> News? {
        let identifier = json["id"].intValue
        if identifier == 0 {
            return nil
        }
        var obj = realm.object(ofType: News.self, forPrimaryKey: identifier)
        if obj == nil {
            obj = News()
            obj?.identifier = identifier
        } else {
            obj = News(value: obj!)
        }
        
        if json["title"].exists() {
            obj?.title = json["title"].string
        }
        
        if json["created_at"].exists() {
            obj?.createdAt = DateHelper.iso8601(dateString: json["created_at"].stringValue)
        }
        if json["updated_at"].exists() {
            obj?.updatedAt = DateHelper.iso8601(dateString: json["updated_at"].stringValue)
        }
        
        return obj
    }
    
    public static func with(json: JSON) -> News? {
        return with(realm: try! Realm(), json: json)
    }
    
    static func fromJson(_ json: JSON) -> News? {
        return with(json: json)
    }
    
}
