//
//  EnvironmentProperties.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 20/09/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import UIKit

class EnvironmentProperties: NSObject {
    
    enum Env {
        case staging, production
    }
    
    static let env: Env = .staging
    
    static func isStaging() -> Bool { env == .staging }
    static func isProduction() -> Bool { env == .production }
    
    public static let facebookAppId = "fb999999999999999999999"
    public static let googleReversedClientId = "com.googleusercontent.apps.9x9x9x9x9x9x9x9x9x9x9x9x9x9x9x9x9x9x"
    public static let mapBoxAccessToken = "pk.x9x9x9x9x9x9x9x9x9.x9x9x9x9x9x9x9x9x"

}
