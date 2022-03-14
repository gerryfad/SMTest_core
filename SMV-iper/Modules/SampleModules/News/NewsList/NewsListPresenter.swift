//
//  NewsListPresenter.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 09/09/20.
//  Copyright © 2020 Rifat Firdaus. All rights reserved.
//

import RxSwift

protocol NewsListPresenterProtocol: BaseProtocol {}

class NewsListPresenter: PaginationPresenter<News> {
    
    weak var view: NewsListPresenterProtocol?
    
    override func refresh() {
        super.refresh()
    }
    
    override func next() {
        let page = pageStatus.currentPage + 1
        NewsApi.getNews(page: page, perPage: perPage)
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
