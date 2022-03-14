//
//  Place.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2019

import Foundation
import SwiftyJSON
import RealmSwift

final class Place: Object, Parseable {
    
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var placeCategoryId: Int = 0
    @objc dynamic var districtId: Int = 0
    @objc dynamic var cityId: Int = 0
    @objc dynamic var placeDocumentsId: Int = 0
    @objc dynamic var ownedBy: Int64 = 0
    @objc dynamic var createdBy: Int64 = 0
    @objc dynamic var managedBy: Int64 = 0
    @objc dynamic var verifiedBy: Int64 = 0
    @objc dynamic var processingBy: Int64 = 0
    @objc dynamic var name: String?
    @objc dynamic var descriptionField: String?
    @objc dynamic var needs: String?
    @objc dynamic var address: String?
    @objc dynamic var residentsNumber: Int = 0
    @objc dynamic var residentsDescription: String?
    //@objc dynamic var foodType: FoodType?
    @objc dynamic var status: String?
    @objc dynamic var placesSlug: String?
    @objc dynamic var phoneMessage: String?
    @objc dynamic var phoneCall: String?
    @objc dynamic var whatsappNumber: String?
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var verifiedAt: Date?
    @objc dynamic var publishedAt: Date?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?
    @objc dynamic var deletedAt: Date?
    @objc dynamic var placeFoodTypeId: Int = 0
    @objc dynamic var placeAdmin: String?
    @objc dynamic var placeCategory: PlaceCategory?
    @objc dynamic var isBookmarked: Bool = false
    @objc dynamic var profileImage: String?
    let coverImage: List<CoverImage> = List<CoverImage>()
    // var coverImageList: List<AnyObject> = List<AnyObject>()
    // var placeStatusHistoryList: List<PlaceStatusHistory> = List<PlaceStatusHistory>()
    @objc dynamic var placeDocument: String?
    // @objc dynamic var district: District?
    // @objc dynamic var city: City?
    // @objc dynamic var owner: AnyObject?
    // @objc dynamic var creator: Creator?
    // var lastDiscussionList: List<AnyObject> = List<AnyObject>()
    
//    @objc dynamic var iamNobodyVariable: String = "iamNobodyVariableValue"
//    @objc dynamic var iamNobodyVariableNil: String? = nil
//    @objc dynamic var iamNobodyGetter: String {
//        return "iamNobodyGetterValue"
//    }
//
//    @objc dynamic var dummy1: String? = nil
//    @objc dynamic var dummy5: String? = nil
    
    override public static func primaryKey() -> String? {
        return "identifier"
    }
    
    // override mappingKeys to customize model-to-json key mapping
    var keyMaps: [String: String]? = [
        "identifier": "id",
        "descriptionField": "description"
    ]
    
    // override snakeCased to control how json keys should be read
    var snakeCased: Bool = true
    
    public static func parseManual(_ json: JSON) -> Place? {
        let obj: Place? = Place()
        if json["id"].exists() {
            obj?.identifier = json["id"].int64Value
        }
        if json["place_category_id"].exists() {
            obj?.placeCategoryId = json["place_category_id"].intValue
        }
        if json["district_id"].exists() {
            obj?.districtId = json["district_id"].intValue
        }
        if json["city_id"].exists() {
            obj?.cityId = json["city_id"].intValue
        }
        if json["owned_by"].exists() {
            obj?.ownedBy = json["owned_by"].int64Value
        }
        if json["created_by"].exists() {
            obj?.createdBy = json["created_by"].int64Value
        }
        if json["managed_by"].exists() {
            obj?.managedBy = json["managed_by"].int64Value
        }
        if json["verified_by"].exists() {
            obj?.verifiedBy = json["verified_by"].int64Value
        }
        if json["processing_by"].exists() {
            obj?.processingBy = json["processing_by"].int64Value
        }
        if json["name"].exists() {
            obj?.name = json["name"].stringValue
        }
        if json["description"].exists() {
            obj?.descriptionField = json["description"].stringValue
        }
        if json["needs"].exists() {
            obj?.needs = json["needs"].stringValue
        }
        if json["address"].exists() {
            obj?.address = json["address"].stringValue
        }
        if json["residents_number"].exists() {
            obj?.residentsNumber = json["residents_number"].intValue
        }
        if json["status"].exists() {
            obj?.status = json["status"].stringValue.lowercased()
        }
        if json["phone_message"].exists() {
            obj?.phoneMessage = json["phone_message"].stringValue
        }
        if json["phone_call"].exists() {
            obj?.phoneCall = json["phone_call"].stringValue
        }
        if json["whatsapp_number"].exists() {
            obj?.whatsappNumber = json["whatsapp_number"].stringValue
        }
        if json["latitude"].exists() && json["longitude"].exists(){
            obj?.latitude = json["latitude"].doubleValue
            obj?.longitude = json["longitude"].doubleValue
        }
        if json["published_at"].exists() {
            obj?.publishedAt = DateHelper.iso8601withoutZone(dateString: json["published_at"].stringValue)
        }
        if json["updated_at"].exists() {
            obj?.updatedAt = DateHelper.iso8601withoutZone(dateString: json["updated_at"].stringValue)
        }
        if json["created_at"].exists() {
            obj?.createdAt = DateHelper.iso8601withoutZone(dateString: json["created_at"].stringValue)
        }
        if json["deleted_at"].exists() {
            obj?.deletedAt = DateHelper.iso8601withoutZone(dateString: json["deleted_at"].stringValue)
        }
        if json["profile_image"].exists() {
            let jsonProfileImage = json["profile_image"]
            obj?.profileImage = jsonProfileImage["image_small_cover"].stringValue
        }
        
        if json["place_category"].exists() {
            obj?.placeCategory = PlaceCategory.parseManual(json["place_category"])
        }
        
        obj?.coverImage.removeAll()
        if json["cover_image"].exists() {
            for jsonCoverImage in json["cover_image"].arrayValue {
                if let cover = CoverImage.parseManual(jsonCoverImage) {
                    obj?.coverImage.append(cover)
                }
            }
        }
        
        if json["is_bookmarked"].exists() {
            obj?.isBookmarked = json["is_bookmarked"].boolValue
        }
        
        return obj
    }
}
