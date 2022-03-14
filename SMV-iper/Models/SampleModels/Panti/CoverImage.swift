//
//  CoverImage.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on August 6, 2019

import Foundation
import SwiftyJSON
import RealmSwift

final class CoverImage: Object, Parseable {
    
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var title: String?
    @objc dynamic var descriptionField: String?
    @objc dynamic var image: String?
    @objc dynamic var imageRatio: Double = 0
    @objc dynamic var publishedAt: Date?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var deletedAt: Date?
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    // override mappingKeys to customize model-to-json key mapping
    var keyMaps: [String: String]? = [
        "identifier": "id",
        "descriptionField": "description"
    ]
    
    // override object date formatter for specific field
    var dateFormats: [String: DateFormatterMethod]? = [
        "publishedAt": DateHelper.iso8601withoutZone(dateString:),
        "createdAt": DateHelper.iso8601withoutZone(dateString:),
        "updatedAt": DateHelper.iso8601withoutZone(dateString:),
        "deletedAt": DateHelper.iso8601withoutZone(dateString:)
    ]
    
    // override from(json:) to customize parsing
    static func from(_ json: JSON) -> CoverImage? {
        guard let obj: CoverImage = parse(json, mergeCache: false) else {
            return nil
        }
        
        // Parse manually because they have different key
        // if json["description"].exists() {
        //     obj.descriptionField = json["description"].string
        // }
        
        return obj
    }
    
    public static func parseManual(_ json: JSON) -> CoverImage? {
        let obj = CoverImage()
        if json["id"].exists() {
            obj.identifier = json["id"].int64Value
        }
        if json["title"].exists() {
            obj.title = json["title"].stringValue
        }
        if json["description"].exists() {
            obj.descriptionField = json["description"].stringValue
        }
        if json["image"].exists() {
            obj.image = json["image"].stringValue
        }
        if json["image_ratio"].exists() {
            obj.imageRatio = json["image_ratio"].doubleValue
        }
        if json["created_at"].exists() {
            obj.createdAt = DateHelper.iso8601withoutZone(dateString: json["created_at"].stringValue)
        }
        if json["updated_at"].exists() {
            obj.updatedAt = DateHelper.iso8601withoutZone(dateString: json["updated_at"].stringValue)
        }
        return obj
    }
}
