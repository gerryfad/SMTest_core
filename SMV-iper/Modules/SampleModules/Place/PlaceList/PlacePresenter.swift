//
//  PlacePresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

protocol PlacePresenterProtocol: BaseProtocol {}

class PlacePresenter: PaginationPresenter<Place> {
    
    weak var view: PlacePresenterProtocol?
    
    // for swiftlint testing purpose
    weak var viewSample1: PlacePresenterProtocol?
    private weak var viewSample2: PlacePresenterProtocol?
    weak public var viewSample3: PlacePresenterProtocol!
    
    override func next() {
        let page = pageStatus.currentPage + 1
        PlaceApi.getPlaces(page: page, perPage: self.perPage)
            .map({ data -> Pagination<[Place]> in
                let pageStatus = PageStatus(total: 0, currentPage: page, lastPage: 0, hasNext: true)
                let pagination = Pagination<[Place]>(pageStatus: pageStatus, data: data)
                return pagination
            })
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
