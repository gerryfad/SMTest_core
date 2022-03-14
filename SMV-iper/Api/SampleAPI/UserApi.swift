//
//  UserApi.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

enum UserApi {
    /// Get users list
    static func getUsers(page: Int, perpage: Int) -> Observable<Pagination<[User]>> {
        return SMEngineService.instance.customResponseUser(
            path    : "https://reqres.in/api/users",
            page    : page,
            perPage : perpage,
            headers     : [:]
        )
    }
}

extension SMEngineService {
    func customResponseUser<T: Parseable>(path: String, page: Int, perPage: Int, parameters: Parameters? = nil, headers: Headers? = nil) -> Observable<Pagination<[T]>> {
        var overridenParameters: [String: Any] = [: ]
        overridenParameters["page"] = page
        overridenParameters["per_page"] = perPage
        overridenParameters.update(dictionary: parameters)
        return requestJson(method: .get, path: path, parameters: overridenParameters, headers: headers)
            .mapObjectsUser(T.self)
            .map { data in
                let pageStatus = PageStatus(total: 0, currentPage: page, lastPage: 0, hasNext: true)
                let pagination = Pagination<[T]>(pageStatus: pageStatus, data: data)
                return pagination
            }
    }
}
