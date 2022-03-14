//
//  NewsDetailPresenter.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 09/09/20.
//  Copyright © 2020 Rifat Firdaus. All rights reserved.
//

import Foundation

protocol NewsDetailPresenterProtocol: BaseProtocol {}

class NewsDetailPresenter: BasePresenter<News> {
    
    weak var view: NewsDetailPresenterProtocol?
    
    func refresh(newsId: Int) {
        NewsApi.getNews(by: newsId)
            .do(onNext: { data in
                self.item = data
                self.view?.showData()
            })
            .do(onError: { error in
                self.view?.showError(error: error)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
