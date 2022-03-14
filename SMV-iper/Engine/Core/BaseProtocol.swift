//
//  BaseProtocol.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/3/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit

protocol BaseProtocol: AnyObject {
    func showData()
    func showError(error: Error?)
}
