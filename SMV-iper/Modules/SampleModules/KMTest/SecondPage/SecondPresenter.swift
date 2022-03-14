//
//  SecondPresenter.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SecondPresenterProtocol: BaseProtocol {
    
}

class SecondPresenter: BasePresenter<User>{
    
    weak var view: SecondPresenterProtocol?
    
    
}
