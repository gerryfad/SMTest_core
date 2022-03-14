//
//  ProfileApi.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 06/08/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import RxSwift
import SwiftyJSON

enum ProfileApi {
    /// Post edit profile with upload file
    static func edit(_ profile: ProfileApi.Create) -> Observable<(Double, JSON?)> {
        return SMEngineService.instance.upload(
            method      : .post,
            path        : "/user/profile",
            data        : profile.asMultipartFormDataClosure
        )
    }
    
    struct Create: Multipartable {
        var token: String?
        var password: String?
        var password_confirm: String?
        var current_password: String?
        var name: String?
        var phone_number: String?
        //var picture: URL?
        var picture: UIImage?
        
        // For testing purpose only
        var pictures: [UIImage]?
        
        /// Override to change default image type
        func imageType() -> ImageType {
            return .jpg
        }
        
        /// Override to change image type per specific key
        func imageTypes() -> [String: ImageType]? {
            return [
                "picture": .png,
                "pictures": .jpg
            ]
        }
        
        /// Override to change default image compression (worst 0.0 - 1.0 best). Only works for jpg.
        func imageCompression() -> CGFloat {
            return 0.5
        }
        
        /// Define image compression per specific key
        func imageCompressions() -> [String: CGFloat]? {
            return [
                "picture": 0.9,
                "pictures": 0.7
            ]
        }
        
        /// Define image filename per specific key.
        /// Key with type array will have extra number behind (pictures-0, pictures-1, pictures-2, ...)
        func fileNames() -> [String: String]? {
            return [
                "picture": "profile-picture",
                "pictures": "many-pictures"
            ]
        }
    }
}

