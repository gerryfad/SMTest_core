//
//  DictionaryExtension.swift
//  Klink Ecommerce
//
//  Created by Alam Akbar Muhammad on 27/02/18.
//  Copyright © 2018 Suitmedia. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public mutating func update(dictionary: Dictionary?) {
        guard let dictionary = dictionary else {
            return
        }
        
        for (key,value) in dictionary {
            self.updateValue(value, forKey:key)
        }
    }
    
}
