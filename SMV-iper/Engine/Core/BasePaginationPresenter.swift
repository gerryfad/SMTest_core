//
//  BasePaginationPresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 17/09/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

protocol PaginationPresenterProtocol {
    func next()
}

typealias PaginationPresenter<T: Object> = BasePaginationPresenter<T>  & PaginationPresenterProtocol

class BasePaginationPresenter<T: Object>: BasePresenter<T> {
    
    public var perPage: Int
    public var pageStatus = PageStatus()
    public var items = [T]()
    
    public init(perPage: Int = 10, params: [String: Any] = [String: Any]()) {
        self.perPage = perPage
        super.init(params: params)
        
    }
    
    public func load() {
        let result = realm.objects(T.self)
        var listData = [T]()
        if result.count > 0 {
            for dataRealm in result {
                let data = dataRealm.detached()
                listData.append(data)
            }
        }
        items.removeAll()
        items.append(contentsOf: listData)
    }
    
    public func refresh() {
        pageStatus.currentPage = 0
        return next()
    }
    
    public func next() {
        
    }
}
