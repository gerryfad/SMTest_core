//
//  JobApi.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 06/08/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import RxSwift

enum JobApi {
    /// Get job list
    static func getJobs(page: Int, perPage: Int) -> Observable<Pagination<[Job]>> {
        return SMEngineService.instance.responsePagination(
            method      : .get,
            path        : "https://commhub.co/api/v1/jobs",
            page        : page,
            perPage     : perPage
        )
    }
    
    /// Get job detail by id
    static func getJob(by id: Int64) -> Observable<Job> {
        return SMEngineService.instance.responseObject(
            method      : .get,
            path        : "https://commhub.co/api/v1/jobs/\(id)"
        )
    }
}
