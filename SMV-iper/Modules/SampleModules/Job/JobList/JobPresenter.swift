//
//  JobPresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import RxSwift

protocol JobPresenterProtocol: BaseProtocol {}

class JobPresenter: PaginationPresenter<Job> {
    
    weak var view: JobPresenterProtocol?
    
    override func refresh() {
        pageStatus.currentPage = 0
        return next()
    }
    
    override func next() {
        JobApi.getJobs(page: self.pageStatus.currentPage + 1, perPage: self.perPage)
            .do(onNext: { pagination in
                self.pageStatus = pagination.pageStatus
                if self.pageStatus.currentPage <= 1 {
                    self.items.removeAll()
                }
                self.items.append(contentsOf: pagination.data)
                self.saveListOfModels(data: pagination.data.detached())
                self.view?.showData()
            })
            .do(onError: { error in
                self.view?.showError(error: error)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
