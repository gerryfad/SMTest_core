//
//  FirstPresenter.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol FirstPresenterProtocol: BaseProtocol {}

class FirstPresenter: BasePresenter<User>{
    
    weak var view: FirstPresenterProtocol?
    
    func showIsPalindrome(word: String, target: UIViewController) {
        var message = ""
       
        
        if word == String(word.reversed()) {
            message = "is Palindrome"
        } else {
            message = "is not Palindrome"
        }
        let alert = UIAlertController(
            title: message,
            message: "text \(message)",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        target.present(alert, animated: true)
    }
}
