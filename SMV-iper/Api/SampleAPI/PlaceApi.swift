//
//  PlaceApi.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 06/08/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

enum PlaceApi {
    /// Get panti list
    static func getPlaces(page: Int, perPage: Int) -> Observable<[Place]> {
        return SMEngineService.instance.responseObjects(
            method      : .get,
            path        : "/places",
            parameters  : Page(page: page, perPage: perPage).dictionary()
        )
    }
    
    /// Get panti detail
    static func getPlace(by id: Int64) -> Observable<Place> {
        return SMEngineService.instance.responseObject(
            method      : .get,
            path        : "/places/\(id)"
        )
        
        //        return Observable.just(JSON(parseJSON: dummyJson))
        //            .mapAPIResponse()
        //            .map { apiResponse in
        //                return apiResponse.result
        //            }
        //            .mapObject(Place.self)
        //            .friendlyError()
    }
    
    /// Post create panti
    static func create(_ place: PlaceApi.Create) -> Observable<APIResponse> {
        return SMEngineService.instance.response(
            method      : .post,
            path        : "/places",
            parameters  : place.dictionary()
        )
    }
    
    /// For paging parameters
    struct Page: Reflectionable {
        var page: Int
        var perPage: Int
    }
    
    /// Post create parameters
    struct Create: Reflectionable {
        var id: Int?
        var place_name: String?
        var address: String?
        var nil_field: String?
    }
}

private let dummyJson = """
{
    "status": 200,
    "message": "Detail of Place #1 retrieved!",
    "result": \(dummyResult)
}
"""


private let dummyResult = """
{
    "id": 1,
    "place_category_id": 1,
    "district_id": null,
    "city_id": 3471,
    "place_documents_id": null,
    "owned_by": null,
    "created_by": 1,
    "managed_by": null,
    "verified_by": null,
    "processing_by": null,
    "name": "Panti Asuhan Yatim Piatu Putra Muhammadiyah",
    "description": "-",
    "needs": "-",
    "address": "JI. Lowanu MG III No.1361, Brontokusuman, Mergangsan, Kota Yogyakarta, Daerah Istimewa Yogyakarta 55153",
    "residents_number": 0,
    "residents_description": "-",
    "status": "new",
    "places_slug": "panti-asuhan-yatim-piatu-putra-muhammadiyah",
    "phone_message": "",
    "phone_call": "0274373113",
    "whatsapp_number": "",
    "latitude": -7.8176891999999993,
    "longitude": 110.36978329999999,
    "verified_at": null,
    "published_at": "2019-08-08 21:07:44",
    "created_at": "2019-08-08 21:07:44",
    "updated_at": "2019-08-08 21:07:44",
    "deleted_at": null,
    "place_food_type_id": 1,
    "place_admin": "",
    "partner_id": null,
    "place_category": {
        "id": 1,
        "name": "Panti Asuhan",
        "places_category_slug": "panti-asuhan",
        "published_at": "2017-01-01 01:00:00",
        "created_at": "2017-01-01 01:00:00",
        "updated_at": "2020-03-16 14:39:28",
        "deleted_at": null,
        "image": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan.png",
        "image_small_square": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail128x128.png",
        "image_medium_square": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail256x256.png",
        "image_small_cover": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail240x_.png",
        "image_normal_cover": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail360x_.png",
        "image_medium_cover": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail480x_.png",
        "image_small_banner": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail_x240.png",
        "image_medium_banner": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail_x480.png",
        "image_thumbnail": "http://panti.suitdev.com/files/placecategoryimage/be6f20cf126610805ceeac2d2ae98412-20200316143928-panti-asuhan_thumbnail.png"
    },
    "is_bookmarked": false,
    "profile_image": null,
    "cover_image": [],
    "place_status_history": [],
    "place_document": null,
    "food_type": {
        "id": 1,
        "name": "Halal",
        "created_at": "2017-01-01 01:00:00",
        "updated_at": "2017-01-01 01:00:00",
        "deleted_at": null
    },
    "district": null,
    "city": {
        "id": 3471,
        "province_id": 34,
        "name": "YOGYAKARTA",
        "cities_slug": "kota-yogyakarta",
        "published_at": null,
        "created_at": "2019-04-30 11:09:09",
        "updated_at": "2019-04-30 11:09:09",
        "deleted_at": null,
        "image": null,
        "image_small_square": null,
        "image_medium_square": null,
        "image_small_cover": null,
        "image_normal_cover": null,
        "image_medium_cover": null,
        "image_small_banner": null,
        "image_medium_banner": null,
        "image_thumbnail": null
    },
    "owner": null,
    "creator": {
        "id": 1,
        "username": "adminpanti2019",
        "email": "adminpanti@panti.id",
        "name": "Admin Panti",
        "birthdate": "1970-01-01 00:00:00",
        "picture": null,
        "phone_number": null,
        "role": "admin",
        "status": "active",
        "timezone": "Asia/Jakarta",
        "phone_verified": 0,
        "registration_date": "2017-01-01 00:00:00",
        "last_visit": "2020-05-19 15:29:24",
        "created_at": "2017-01-01 01:00:00",
        "updated_at": "2020-05-19 15:29:24",
        "email_verified": 1,
        "picture_small_square": null,
        "picture_medium_square": null,
        "picture_small_cover": null,
        "picture_normal_cover": null,
        "picture_medium_cover": null,
        "picture_small_banner": null,
        "picture_medium_banner": null,
        "picture_thumbnail": null
    },
    "partner": null,
    "last_discussion": [],
    "is_donation_available": false
}
"""
