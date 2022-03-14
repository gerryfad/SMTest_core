//
//  GithubApi.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 07/08/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import RxSwift
import Alamofire

/// Because github response is using different json format, we can manually map them.
enum GithubApi {
    /// Get or search repo list by userId (using custom mapper)
    static func searchRepo(user: String, page: Int, perPage: Int) -> Observable<Pagination<[Repo]>> {
        return SMEngineService.instance.customResponseGithub(
            path        : "https://api.github.com/users/\(user)/repos",
            page        : page,
            perPage     : perPage,
            headers     : [:]
        )
    }
}

// MARK: - Custom mapper

extension SMEngineService {
    /// github response custom mapper
    func customResponseGithub<T: Parseable>(path: String, page: Int, perPage: Int, parameters: Parameters? = nil, headers: Headers? = nil) -> Observable<Pagination<[T]>> {
        var overridenParameters: [String: Any] = [: ]
        overridenParameters["page"] = page
        overridenParameters["per_page"] = perPage
        overridenParameters.update(dictionary: parameters)
        return requestJson(method: .get, path: path, parameters: overridenParameters, headers: headers)
            .mapObjects(T.self)
            .map { data in
                let pageStatus = PageStatus(total: 0, currentPage: page, lastPage: 0, hasNext: true)
                let pagination = Pagination<[T]>(pageStatus: pageStatus, data: data)
                return pagination
        }
    }
}
