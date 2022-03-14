//
//  RepoPresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RepoPresenterProtocol: BaseProtocol {}

class RepoPresenter: PaginationPresenter<Repo> {

    weak var view: RepoPresenterProtocol?
    
    func refresh(user: String) {
        self.pageStatus.currentPage = 1
        return self.next(user: user)
    }
    
    func next(user: String) {
        Observable.just(user)
            .flatMapLatest { user in
                // We can create searchRepo request inside service
                // self.service.searchRepo(user: user, params: self.params, page: self.pageStatus.currentPage, perPage: self.perPage)
                
                // .. or in separate api request file.
                GithubApi.searchRepo(user: user, page: self.pageStatus.currentPage, perPage: self.perPage)
            }
            .do(onNext: { pagination in
                self.pageStatus = pagination.pageStatus
                if self.pageStatus.currentPage <= 1 {
                    self.items.removeAll()
                    self.removeAllModelsOf(type: Repo.self)
                }
                self.pageStatus.currentPage += 1
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
