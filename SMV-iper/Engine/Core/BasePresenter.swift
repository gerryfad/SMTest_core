// swiftlint:disable all
//
//  BasePresenter.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import SwiftyJSON

import RxSwift
import RxCocoa

class BasePresenter<T: Object>: NSObject {

    public var service = SMEngineService.instance
    public var disposeBag = DisposeBag()
    public var params: [String: Any]
    public var item: T?
    
    private var _realm: Realm?
    
    public var realm: Realm {
        if let realm = _realm {
            return realm
        }
        return try! Realm()
    }
    
    public init(params: [String: Any] = [String: Any]()) {
        self.params = params
    }
    
    func load(id: Any) {
        let result = realm.object(ofType: T.self, forPrimaryKey: id)
        item = result?.detached()
    }
    
    public func saveModel(data: Object) {
        try! self.realm.write {
            self.realm.add(data, update: .modified)
        }
        
    }
    
    public func saveListOfModels(data: [Object]) {
        try! self.realm.write {
            self.realm.add(data, update: .modified)
        }
    }
    
    public func removeAllModelsOf<T: RealmSwift.Object>(type: T.Type, filter: String? = nil) {
        if let filter = filter {
            let result = self.realm.objects(type).filter(filter)
            try! self.realm.write {
                self.realm.delete(result)
                print("\(type.description()) deleted, filter : \(filter)")
            }
        } else {
            let result = self.realm.objects(type)
            try! self.realm.write {
                self.realm.delete(result)
                print("\(type.description()) deleted")
            }
        }
    }
    
}
