//
//  JobDetailPresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

protocol JobDetailPresenterProtocol: BaseProtocol {}

class JobDetailPresenter: BasePresenter<Job> {
    
    weak var view: JobDetailPresenterProtocol?
    
    func refresh(jobId: Int64) {
        JobApi.getJob(by: jobId)
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
