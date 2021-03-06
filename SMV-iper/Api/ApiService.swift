//
//  ApiService.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/1/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RxSwift
import RxCocoa

extension SMEngineService {
    
    /// Post login
    func login(username: String, password: String) -> Observable<Owner> {
        return responseObject(
            method      : .post,
            path        : "/login",
            parameters  : [
                "username": username,
                "password": password
            ]
        )
    }
    
    /// Post login
    func login(username: String, password: String) -> Observable<JSON> {
        return requestJson(
            method      : .post,
            path        : "/login",
            parameters  : [
                "username": username,
                "password": password
            ]
        )
    }
    
    /// Get news list (with pagination)
    func news(page: Int, perPage: Int) -> Observable<Pagination<[News]>> {
        return responsePagination(
            method  : .get,
            path    : "/news",
            page    : page,
            perPage : perPage
        )
    }
    
    /// Get news detail by id
    func news(id newsId: Int) -> Observable<News> {
        return responseObject(
            method  : .get,
            path    : "/news/\(newsId)"
        )
    }
    
    /// Get news list by top5 category (no pagination)
    func newsTop5() -> Observable<[News]> {
        return responseObjects(
            method  : .get,
            path    : "/news/top5"
        )
    }
    
    // use the pagination as usual
    //
//    func searchRepo(user:String, params: [String:Any], page: Int = 1, perPage: Int = 10) -> Observable<Pagination<[Repo]>> {
//        var parameters: [String:Any] = [
//            "per_page" : perPage,
//            "page" : page
//        ]
//        for (key, value) in params {
//            parameters[key] = value as Any?
//        }
//        // Access token here
//        //        if let token = PreferenceManager.instance.token {
//        //            parameters["access_token"] = token
//        //        }
//        return manager.requestJSON(.get, home + "/users/\(user)/repos", parameters: parameters, headers: headers)
//            //            .printJson()
//            //            .mapAPIResponse()
//            .mapJson()
//            .do(onError: { error in
//                print("🚫 \(error.localizedDescription)")
//            })
//            .map({ data in
//                // pagination
//                if let code = data.code {
//                    if let result = data.result, code == self.successCode {
//                        let pageStatus = PageStatus.with(json: result)
//                        let dataJson = result["data"]
//                        var dataList = [News]()
//                        for item in dataJson.arrayValue {
//                            if let match = News.with(json: item) {
//                                dataList.append(match)
//                            }
//                        }
//                        let pagination = Pagination<[News]>(pageStatus: pageStatus, data: dataList)
//                        return pagination
//                    } else {
//                        throw ErrorHelper.instance.getErrorFrom(apiResponse: data)
//                    }
//                } else {
//                    throw ErrorHelper.instance.getErrorWith(code: .unknownError)
//                }
//            })
//    }
    
}
