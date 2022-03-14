//
//  ObservableExtensions.swift
//
//  Created by Rifat Firdaus on 10/1/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift

extension Observable {
    
    func printJson() -> Observable {
        return self.do(onNext: { item in
            //            print(item)
            if let data = item as? (HTTPURLResponse, Any) {
                print(data.1)
            } else {
                print(item)
            }
        })
    }
    
    /// Convert http response to JSON.
    /// Use this if response is a valid Suitmobile json format.
    /// Otherwise, please make a new map function.
    func mapAPIResponse() -> Observable<APIResponse> {
        return map { (item: Element) -> APIResponse in
            let response: HTTPURLResponse?
            let json: JSON
            if let data = item as? (HTTPURLResponse, Any) {
                response = data.0
                json = JSON(data.1)
            } else if let data = item as? JSON {
                response = nil
                json = data
            } else {
                fatalError("expected HTTPURLResponse or JSON")
            }
            
            // get status code
            let jsonCode = json[APIResponse.Key.code].stringValue
            let code = Int(jsonCode) ?? response?.statusCode
            
            // get message
            let message = json[APIResponse.Key.message].string
            
            // get result
            let result = json[APIResponse.Key.result]
            
            if let code = code, let message = message {
                return APIResponse(message: message, code: code, result: result)
            }
            
            throw Self.invalidResponse("response code or message does not exist")
        }
    }
    
    /// Check APIResponse code success (usually 200), otherwise throw error.
    func validateSuccess() -> Observable<APIResponse> {
        return map { item -> APIResponse in
            guard let apiResponse = item as? APIResponse else {
                fatalError("expected APIResponse")
            }
            if let code = apiResponse.code, code >= 200, code <= 299 {
                return apiResponse
            }
            throw ErrorHelper.instance.getErrorFrom(apiResponse: apiResponse)
        }
    }
    
    /// Validate token expired.
    func validateTokenExpired() -> Observable {
        return takeWhile { (item) -> Bool in
            guard let apiResponse = item as? APIResponse else {
                throw ErrorHelper.instance.create(Lstr.somethingWentWrong.tr())
            }
            if let code = apiResponse.code, code == 403 {
                print(apiResponse)
                KeyChainHelper.instance.clear()
                UIApplication.setRootView(MainTabBarController.instantiate())
                return false
            }
            return true
        }
    }
    /// Convert http response to JSON
    func mapJson() -> Observable<JSON> {
        return map { (item: Element) -> JSON in
            guard let data = item as? (HTTPURLResponse, Any) else {
                fatalError("expected HTTPURLResponse")
            }
            let json = JSON(data.1)
            return json
        }
    }
    
    /// Convert APIResponse (.result) to JSON
    func mapResponseJson() -> Observable<JSON> {
        return map { item -> JSON in
            guard let apiResponse = item as? APIResponse else {
                fatalError("expected APIResponse")
            }
            guard let json = apiResponse.result else {
                throw Self.invalidResponse("expected json result")
            }
            return json
        }
    }
    
    /// Convert JSON to Object
    func mapObject<T: Parseable>(_ ofType: T.Type) -> Observable<T> {
        return map { item -> T in
            guard let json = item as? JSON else {
                fatalError("expected JSON")
            }
            guard let _ = json.dictionary else {
                throw Self.invalidResponse("expected json object")
            }
            guard let obj = T.from(json) else {
                throw Self.invalidResponse("failed to parse object")
            }
            return obj
        }
    }
    
    /// Convert JSON array to array of Object
    func mapObjects<T: Parseable>(_ ofType: T.Type) -> Observable<[T]> {
        return map { item -> [T] in
            guard let data = item as? JSON else {
                fatalError("expected JSON")
            }
            guard let array = data.array else {
                throw Self.invalidResponse("expected json array")
            }
            var dataList = [T]()
            for jsonItem in array {
                if let obj = T.from(jsonItem) {
                    dataList.append(obj)
                }
            }
            return dataList
        }
    }
    
    /// Custom Convert JSON array to array of Object
    func mapObjectsUser<T: Parseable>(_ ofType: T.Type) -> Observable<[T]> {
        return map { item -> [T] in
            guard let data = item as? JSON else {
                fatalError("expected JSON")
            }
            guard let array = data["data"].array else {
                throw Self.invalidResponse("expected json array")
            }
            var dataList = [T]()
            for jsonItem in array {
                if let obj = T.from(jsonItem) {
                    dataList.append(obj)
                }
            }
            return dataList
        }
    }
   
    
    /// Convert JSON to Object or nil
    func mapObjectOrNil<T: Parseable>(_ ofType: T.Type) -> Observable<T?> {
        return map { item -> T? in
            guard let json = item as? JSON else {
                fatalError("expected json")
            }
            guard let _ = json.dictionary else {
                return nil
            }
            guard let obj = T.from(json) else {
                return nil
            }
            return obj
        }
    }
    
    /// Convert APIResponse.result to Object
    func mapResponseObject<T: Parseable>(_ ofType: T.Type) -> Observable<T> {
        return map { item -> APIResponse in
            guard let apiResponse = item as? APIResponse else {
                fatalError("expected APIResponse")
            }
            return apiResponse
        }
        .map { apiResponse -> JSON in
            guard let json = apiResponse.result else {
                throw Self.invalidResponse("expected json result")
            }
            return json
        }
        .mapObject(ofType)
    }
    
    /// Convert APIResponse.result to Object or nil
    func mapResponseObjectOrNil<T: Parseable>(_ ofType: T.Type) -> Observable<T?> {
        return map { item -> APIResponse in
            guard let apiResponse = item as? APIResponse else {
                fatalError("expected api response")
            }
            return apiResponse
        }
        .map { apiResponse -> JSON in
            guard let json = apiResponse.result else {
                throw Self.invalidResponse("expected json")
            }
            return json
        }
        .mapObjectOrNil(ofType)
    }
    
    /// Convert APIResponse.result to array of Object
    func mapResponseObjects<T: Parseable>(_ ofType: T.Type) -> Observable<[T]> {
        return map { item -> APIResponse in
            guard let apiResponse = item as? APIResponse else {
                fatalError("expected APIResponse")
            }
            return apiResponse
        }
        .map { apiResponse -> JSON in
            guard let json = apiResponse.result else {
                throw Self.invalidResponse("expected json result")
            }
            return json
        }
        .mapObjects(ofType)
    }
    
    /// Convert APIResponse.result to Pagination
    func mapResponsePagination<T: Parseable>(_ ofType: T.Type) -> Observable<Pagination<[T]>> {
        return flatMap { item -> Observable<([T], PageStatus)> in
            guard let apiResponse = item as? APIResponse else {
                fatalError("expected APIResponse")
            }
            guard let jsonResult = apiResponse.result else {
                throw Self.invalidResponse("expected json result")
            }
            
            // look for json data inside pagination
            let jsonData = jsonResult[PageStatus.Key.data]
            guard jsonData.exists() else {
                throw Self.invalidResponse("expected json pagination")
            }
            
            let observableData = Observable<JSON>.just(jsonData)
                .mapObjects(ofType)
            let observablePageStatus = Observable<PageStatus?>
                .just(PageStatus.with(json: jsonResult))
                .map { pageStatus -> PageStatus in
                    guard let pageStatus = pageStatus else {
                        throw Self.invalidResponse("expected PageStatus")
                    }
                    return pageStatus
                }
            return Observable<Any>.zip(observableData, observablePageStatus)
        }
        .map({ data, pageStatus -> Pagination<[T]> in
            let pagination = Pagination<[T]>(pageStatus: pageStatus, data: data)
            return pagination
        })
    }
    
    func friendlyError() -> Observable<Element> {
        return self.do(onError: { error in
            throw ErrorHelper.friendlyError(from: error)
        })
    }
    
    // MARK: - HELPER
    
    static func invalidResponse(_ reason: String) -> Error {
        return ErrorHelper.instance.create(reason, ErrorCode.invalidResponse.rawValue)
    }
    
}

