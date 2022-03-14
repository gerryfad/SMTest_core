//
//  PlaceDetailPresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

protocol PlaceDetailPresenterProtocol: BaseProtocol {}

class PlaceDetailPresenter: BasePresenter<Place> {
    
    weak var view: PlaceDetailPresenterProtocol?
    
    func refresh(placeId: Int64) {
        PlaceApi.getPlace(by: placeId)
            .do(onNext: { data in
                self.item = data
                self.saveModel(data: data)
                self.view?.showData()
            })
            .do(onError: { error in
                self.view?.showError(error: error)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func create() {
        let newPlace = PlaceApi.Create(id: -2, place_name: "axu", address: "my address", nil_field: nil)
        PlaceApi.create(newPlace)
            .do(onNext: { response in
                print(response)
                self.view?.showData()
            })
            .do(onError: { error in
                self.view?.showError(error: error)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
