// swiftlint:disable all
//
//  SMCoreConfig.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 18/09/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

class SMCoreConfig {
    
    static let headers: () -> Headers = {
        // return [
        //     "X-PublicKey": "",
        //     "X-HashKey": ""
        // ]
        return Authorization.bearer(PreferenceManager.instance.token)
    }
    
}
