//
//  LanguageEnum.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 05/07/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import Foundation

// Sesuaikan case dengan jumlah bahasa lozalizable

enum ProjLanguage: String, CaseIterable {
    case english = "en"
    case indonesia = "id"
    
    func getValue() -> String {
        return self.rawValue
    }
    
    func getDescription() -> String {
        switch self {
        case .english:
            return "English"
        case .indonesia:
            return "Bahasa Indonesia"
        }
    }
    
    static func getValueFromDesc(description: String) -> String {
        for value in ProjLanguage.allCases {
            if description == value.getDescription() {
                return value.getValue()
            }
        }
        return "en"
    }
    
    static func getArrayString() -> [String] {
        var arrayString: [String] = []
        for value in ProjLanguage.allCases {
            arrayString.append(value.getDescription())
        }
        return arrayString
    }
}
