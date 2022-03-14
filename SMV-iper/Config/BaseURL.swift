//
//  BaseURL.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/1/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

open class BaseURL: NSObject {

    static var baseUrl: String {
        switch EnvironmentProperties.env {
        case .staging:
            return "http://panti.suitdev.com"
        case .production:
            return "http://panti.suitdev.com"
        }
    }
    
    static var apiUrl: String {
        switch EnvironmentProperties.env {
        case .staging:
            return "\(baseUrl)/api"
        case .production:
            return "\(baseUrl)/api"
        }
    }
    
}
