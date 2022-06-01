// ThirdPresenter.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ThirdPresenterProtocol: BaseProtocol {
}

class ThirdPresenter: PaginationPresenter<User> {
    weak var view: ThirdPresenterProtocol?
    
    override func refresh() {
        super.refresh()
    }
    
    override func next() {
        let page = pageStatus.currentPage + 1
        UserApi.getUsers(page: page, perpage: perPage)
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

