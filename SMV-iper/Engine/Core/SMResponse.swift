// swiftlint:disable all
//
//  ApiResponse.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 17/09/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import SwiftyJSON

// MARK: - Model Response

struct APIResponse {
    struct Key {
        static let code = "status"
        static let message = "message"
        static let result = "result"
    }
    
    var message: String?
    var code: Int?
    var result: JSON?
}

public enum APIResult<T> {
    case success(T)
    case failure(NSError)
}

// MARK: - Model Pagination

public struct Pagination<T> {
    public let pageStatus: PageStatus
    public let data: T
    
    public init(pageStatus: PageStatus, data: T) {
        self.pageStatus = pageStatus
        self.data = data
    }
}

// MARK: - Model Page Status

public struct PageStatus {
    struct Key {
        static let data = "data"
    }
    
    public var total: Int = 0
    public var currentPage: Int = 1
    //    public var nextPage: Int = 1
    public var lastPage: Int = 0
    public var hasNext: Bool = false
    
    public static func with(json: JSON) -> PageStatus {
        var pageStatus = PageStatus()
        pageStatus.total = json["total"].intValue
        pageStatus.currentPage = json["current_page"].intValue
        pageStatus.lastPage = json["last_page"].intValue
        pageStatus.hasNext = false
        if let _ = json["next_page_url"].string {
            pageStatus.hasNext = true
        }
        return pageStatus
    }
    
    struct RequestKey: Reflectionable {
        let page: Int
        let per_page: Int
        
        init(_ page: Int, _ per_page: Int) {
            self.page = page
            self.per_page = per_page
        }
    }
}
