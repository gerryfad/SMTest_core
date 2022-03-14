//
//  NewsApi.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 09/09/20.
//  Copyright © 2020 Rifat Firdaus. All rights reserved.
//

import RxSwift

enum NewsApi {
    /// Get news list
    static func getNews(page: Int, perPage: Int) -> Observable<Pagination<[News]>> {
        return SMEngineService.instance.responsePagination(
            method      : .get,
            path        : "/news",
            page        : page,
            perPage     : perPage
        )
    }
    
    /// Get news detail by id
    static func getNews(by id: Int) -> Observable<News> {
        return SMEngineService.instance.responseObject(
            method      : .get,
            path        : "/news/\(id)"
        )
    }
}
