//
//  LocaleManager.swift
//
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

enum AladinCurrency {
    case USD
    case IDR
}

struct SMLocaleView {
    func showLanguagePicker(sender: Any, doneBlock: @escaping (_ picker: ActionSheetStringPicker?, _ index: Int, _ value: Any?) -> Void, cancelBlock: @escaping () -> Void) {
        let array = ProjLanguage.getArrayString()
        var currentIndex = 0
        if let lang = ProjLanguage(rawValue: PreferenceManager.instance.language) {
            if let idx = array.firstIndex(of: lang.getDescription()) {
                currentIndex = idx
            }
        }
        ActionSheetStringPicker.show(withTitle: Lstr.selectLanguage.tr(), rows: array, initialSelection: currentIndex, doneBlock: {
            picker, index, value in
            doneBlock(picker, index, value)
            if let value = value {
                PreferenceManager.instance.language = ProjLanguage.getValueFromDesc(description: String(describing: value))
                LocaleManager.instance.language = ProjLanguage(rawValue: PreferenceManager.instance.language) ?? .english
            }
        }, cancel: { actionSheetStringPicker in
            cancelBlock()
        }, origin: sender)
    }
    
    func showLanguageSheetPicker(controller: UIViewController, doneBlock: @escaping (_ picker: UIAlertController, _ value: Any?) -> Void, cancelBlock: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        ProjLanguage.getArrayString().forEach { (title) in
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                doneBlock(alert, title)
                PreferenceManager.instance.language = ProjLanguage.getValueFromDesc(description: String(describing: title))
                LocaleManager.instance.language = ProjLanguage(rawValue: PreferenceManager.instance.language) ?? .english
            }))
        }
        alert.addAction(UIAlertAction(title: Lstr.cancel.tr(), style: .cancel, handler: { action in
            cancelBlock()
        }))
        controller.present(alert, animated: true, completion: nil)
    }
}

class LocaleManager: NSObject {

    static let instance = LocaleManager()
    
    let viewLocale = SMLocaleView()
    
    private let numberFormatter = NumberFormatter()
    private let dateFormatter = DateFormatter()

    var language: ProjLanguage {
        get {
            return ProjLanguage(rawValue: PreferenceManager.instance.language) ?? .english
        }

        set(newLanguage) {
            PreferenceManager.instance.language = newLanguage.rawValue
            _ = languageSetup(language: PreferenceManager.instance.language)
        }
    }

//    var currency: AladinCurrency {
//        get {
//            if let currencyString = PreferenceManager.instance.currency {
//                if currencyString == "USD" {
//                    return .USD
//                }
//            }
//            return .IDR
//        }
//        set {
//            if newValue == .USD {
//                PreferenceManager.instance.currency = "USD"
//                return
//            }
//            PreferenceManager.instance.currency = "IDR"
//        }
//    }

    var bundle: Bundle?
    
    // tempBundle untuk kebutuhan translasi on demand, bukan by current active language.
    private var tempBundle: Bundle?
    private var tempBundleLang: String?

    override init() {
        super.init()
        
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        let language = PreferenceManager.instance.language
        self.language = ProjLanguage(rawValue: language) ?? ProjLanguage.english
        _ = languageSetup(language: language)
    }
    
    private func getBundle(language: String?) -> Bundle {
        var tempLangue: String?
        if let language = language {
            tempLangue = language
        } else {
            tempLangue = "en"
        }
        var bundle: Bundle?
        let path = Bundle.main.path(forResource: tempLangue, ofType: "lproj")
        if path != nil {
            bundle = Bundle(path: path!)
        }
        if bundle == nil {
            bundle = Bundle.main
        }
        return bundle!
    }

    func languageSetup(language: String?) -> Bundle {
        var tempLangue: String?
        if let language = language {
            tempLangue = language
        } else {
            tempLangue = "en"
        }
        var bundle: Bundle?
        let path = Bundle.main.path(forResource: tempLangue, ofType: "lproj")
        if path != nil {
            bundle = Bundle(path: path!)
        }
        if bundle == nil {
            bundle = Bundle.main
        }
        self.bundle = bundle
        return bundle!
    }

    func localizedStringForKey(key: String) -> String {
        if let bundle = self.bundle {
            return bundle.localizedString(forKey: key, value: "", table: nil)
        } else {
            let language = PreferenceManager.instance.language
            return languageSetup(language: language).localizedString(forKey: key, value: "", table: nil)
        }
    }
    
    func localizedStringForKey(key: String, language: ProjLanguage) -> String {
        if let bundle = tempBundle, language.rawValue == tempBundleLang {
            return bundle.localizedString(forKey: key, value: "", table: nil)
        } else {
            tempBundle = getBundle(language: language.rawValue)
            tempBundleLang = language.rawValue
            return tempBundle!.localizedString(forKey: key, value: "", table: nil)
        }
    }

    func formatPrice(price: Double, currency: String?, abbreviate: Bool = false) -> String {
        let currency = currency != nil ? currency! : ""
        var result = ""
        if currency.caseInsensitiveCompare("USD") == .orderedSame {
            numberFormatter.groupingSeparator = ","
            numberFormatter.decimalSeparator = "."
            numberFormatter.minimumIntegerDigits = 1
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            result = "USD \(numberFormatter.string(from: NSNumber(value: price))!)"
        } else {
            var suffix = ""
            var price = price
            if abbreviate && price > 1000000 {
                suffix = "jt"
                price = price / 1000000
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
            } else if abbreviate && price > 1000 {
                suffix = "rb"
                price = price / 1000
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 0
            } else {
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 0
            }
            numberFormatter.groupingSeparator = "."
            numberFormatter.decimalSeparator = ","
            result = "IDR \(numberFormatter.string(from: NSNumber(value: price))!)\(suffix)"
        }
        return result
    }

//    func formatDate(date: NSDate, format: String? = nil, style: DateFormatter.Style? = nil) -> String {
//        var localeIdentifier = "en_US"
//        if language == .indonesia {
//            localeIdentifier = "id_ID"
//        }
//        dateFormatter.locale = NSLocale(localeIdentifier: localeIdentifier) as Locale!
//        if let format = format {
//            dateFormatter.dateFormat = format
//        }
//        if let style = style {
//            dateFormatter.dateStyle = style
//        }
//        return dateFormatter.string(from: date as Date)
//    }

    static func isEnglish() -> Bool {
        return instance.language == .english
    }
    
    static func isIndonesia() -> Bool {
        return instance.language == .indonesia
    }
    
}

extension Date {
    
    /// Format date by ProjLanguage + current Timezone.
    /// - Parameters:
    ///   - format: date format (ex: dd MM yyyy)
    ///   - projLang: language used by app (enum ProjLanguage).
    /// - Returns: Formatted date string
    func formatLT(_ format: String, projLang: ProjLanguage = LocaleManager.instance.language) -> String {
        return formatter(format: format, configuration: { formatter in
            formatter.locale = Locale(identifier: projLang.rawValue)
            formatter.timeZone = TimeZone.current
        }).string(from: self)
    }
    
}
