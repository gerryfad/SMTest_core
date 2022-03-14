// swiftlint:disable all
//
//  Parseable.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 29/07/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import SwiftyJSON
import RealmSwift

typealias DateFormatterMethod = (String) -> Date?

protocol Parseable: Reflectionable {
    var snakeCased: Bool { get }
    var keyMaps: [String: String]? { get }
    var dateFormats: [String: DateFormatterMethod]? { get }
    var dateFormatter: DateFormatterMethod { get }
    static func from(_ json: JSON) -> Self?
    static func parse<T>(_ json: JSON, mergeCache: Bool) -> T? where T: Parseable
}

fileprivate var parseableCache: [String: (typeMap: [String: Any]?, keyMap: [String: String]?)] = [:]

extension Parseable {
    var snakeCased: Bool {
        return true
    }
    
    var keyMaps: [String: String]? {
        return nil
    }
    
    var dateFormats: [String: DateFormatterMethod]? {
        return nil
    }
    
    /// default date formatter
    var dateFormatter: DateFormatterMethod {
        return DateHelper.iso8601(dateString:)
    }
        
    static func from(_ json: JSON) -> Self? {
        return parse(json, mergeCache: false)
    }
    
    /// Parse json into object.
    static func parse<T>(_ json: JSON, mergeCache: Bool = false) -> T? where T: Parseable {
        guard let realmType = T.self as? Object.Type else {
            fatalError("\(T.self) must be a realm 'Object'")
        }
        
        let realmObject = realmType.init()
        
        guard realmObject is T else {
            fatalError("\(T.self) must be a 'Parseable' protocol")
        }
        
        // it is safe to force cast as! T, because we guard it.
        var obj: T = realmObject as! T
        
        var mirror: Dictionary<String, Any>?
        let selfName = String(describing: self)
        if let cachedMirror = parseableCache[selfName]?.typeMap {
            mirror = cachedMirror
            //print("use cached mirror for \(selfName) \(mirror!.count)")
        } else {
            mirror = obj.dictionary()
            parseableCache[selfName] = (typeMap: mirror, keyMap: [:])
            //print("new mirror for \(selfName) \(mirror!.count)")
        }
        
        if var mirror = mirror {
            if mergeCache {
                let itemKeyId = realmType.primaryKey()!
                guard let itemValueId = mirror[itemKeyId] else {
                    print("mirror of primaryKey not found")
                    return nil
                }
                
                guard let keyId = obj.keyMap(of: itemKeyId) else {
                    print("keyId nil")
                    return nil
                }
                
                let identifier = parseValue(json[keyId], with: itemValueId)
                if let cache = try? Realm().object(ofType: realmType.self, forPrimaryKey: identifier)?.detached() as? T {
                    obj = cache
                    
                    // Remove keyId to prevent repeat parsing.
                    mirror.removeValue(forKey: itemKeyId)
                }
            }
            
            for item in mirror {
                //print("item: \(item.key)")
                guard let key = obj.keyMap(of: item.key) else {
                    continue
                }
                //print("\(key) : \(json[key])")
                
                if json[key].exists() {
                    let dateFormatterMethod = obj.dateFormats?[item.key] ?? obj.dateFormatter
                    let data = parseValue(json[key], with: item.value, formatter: dateFormatterMethod)
                    (obj as? Object)?.setValue(data, forKey: item.key)
                }
            }
        }
        
        return obj
    }
    
    /// Return mapped key if exist, or else using default (their own name).
    private func keyMap(of itemKey: String) -> String? {
        // Use mapped key if exist.
        if let mappedKey = self.keyMaps?[itemKey] {
            return mappedKey
        }
        // Convert to snakeCased. Use cached one if any.
        else if self.snakeCased {
            let selfName = String(describing: Self.self)
            if let cachedKey = parseableCache[selfName]?.keyMap?[itemKey] {
                //print("use cached key for \(selfName) is \(cachedKey)")
                return cachedKey
            } else {
                guard let key = itemKey.snakeCased() else {
                    print("failed convert to snakecase")
                    return nil
                }
                parseableCache[selfName]?.keyMap?[itemKey] = key
                //print("new map key for \(selfName) is \(key)")
                return key
            }
        }
        // Or use default key name
        else {
            return itemKey
        }
    }
    
    /// Parse json into primitive type, single object or list.
    private static func parseValue(_ json: JSON, with itemValueType: Any, formatter: DateFormatterMethod? = nil) -> Any? {
        let itemType: Any.Type
        if let itemOptional = itemValueType as? OptionalProtocol {
            itemType = itemOptional.wrappedType()
        } else {
            itemType = type(of: itemValueType)
        }
        
        if itemType is Int.Type {
            return json.intValue
        } else if itemType is Int64.Type {
            return json.int64Value
        } else if itemType is Float.Type {
            return json.floatValue
        } else if itemType is Double.Type {
            return json.doubleValue
        } else if itemType is Bool.Type {
            return json.boolValue
        } else if itemType is String.Type {
            return json.string
        } else if itemType is Date.Type {
            return formatter?(json.stringValue)
        } else if itemType is Parseable.Type {
            //print("parse object")
            if json == JSON.null {
                return nil
            }
            let data = (itemType as? Parseable.Type)?.from(json)
            return data
        } else if itemType is ListProtocol.Type {
            //print("parse array of object \(itemType)")
            let listType = itemType as? ListProtocol.Type
            let elementType = listType?.getElement()
            if let parseableType = elementType as? Parseable.Type {
                var data = [Parseable]()
                for itemJson in json.arrayValue {
                    if let item = parseableType.from(itemJson) {
                        data.append(item)
                    }
                }
                return data
            } else if let _ = elementType as? String.Type {
                var data = [String]()
                for itemJson in json.arrayValue {
                    data.append(itemJson.string ?? "")
                }
                return data
            }
            return nil
        } else {
            fatalError("parseable field type checking not implemented (\(itemType))")
        }
    }
    
    // MARK: - UTILITY
    
    static func clearCache() {
        parseableCache.removeAll()
    }
}

fileprivate protocol ListProtocol {
    static func getElement() -> Any.Type
}
extension List: ListProtocol {
    fileprivate static func getElement() -> Any.Type {
        return Element.self
    }
}

fileprivate protocol OptionalProtocol {
    func wrappedType() -> Any.Type
}
extension Optional: OptionalProtocol {
    fileprivate func wrappedType() -> Any.Type {
        return Wrapped.self
    }
}
