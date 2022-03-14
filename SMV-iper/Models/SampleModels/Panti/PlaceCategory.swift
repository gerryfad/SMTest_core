//
//  PlaceCategory.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2019

import Foundation
import SwiftyJSON
import RealmSwift

final class PlaceCategory: Object, Parseable {
    
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    @objc dynamic var placesCategorySlug: String?
    @objc dynamic var publishedAt: Date?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var deletedAt: Date?
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }

    // override mappingKeys to customize model-to-json key mapping
    var keyMaps: [String: String]? = [
        "identifier": "id"
    ]
    
    // override object date formatter
    var dateFormatter: DateFormatterMethod {
        return DateHelper.iso8601withoutZone(dateString:)
    }
    
    // override from(json:) to customize parsing
    static func from(_ json: JSON) -> PlaceCategory? {
        guard let obj: PlaceCategory = parse(json, mergeCache: false) else {
            return nil
        }
        
        // Parse manually because createdAt using custom date format.
        // if json["created_at"].exists() {
        //     obj.createdAt = DateHelper.iso8601withoutZone(dateString: json["created_at"].stringValue)
        // }
        
        return obj
    }
    
    public static func parseManual(_ json: JSON) -> PlaceCategory? {
        let obj = PlaceCategory()
        if json["id"].exists() {
            obj.identifier = json["id"].int64Value
        }
        if json["name"].exists() {
            obj.name = json["name"].stringValue
        }
        if json["image"].exists() {
            obj.image = json["image"].stringValue
        }
        if json["places_category_slug"].exists() {
            obj.placesCategorySlug = json["places_category_slug"].stringValue
        }
        if json["published_at"].exists() {
            obj.publishedAt = DateHelper.iso8601(dateString: json["published_at"].stringValue)
        }
        if json["updated_at"].exists() {
            obj.updatedAt = DateHelper.iso8601withoutZone(dateString: json["updated_at"].stringValue)
        }
        if json["created_at"].exists() {
            obj.createdAt = DateHelper.iso8601withoutZone(dateString: json["created_at"].stringValue)
        }
        if json["deleted_at"].exists() {
            obj.deletedAt = DateHelper.iso8601withoutZone(dateString: json["deleted_at"].stringValue)
        }
        return obj
    }
}
