//
//  FileManagerExtension.swift
//  CommHub
//
//  Created by Alam Akbar Muhammad on 16/07/19.
//  Copyright © 2019 Suitmedia. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// App main directory name
    /// Biasanya digunakan untuk menyimpan dokumen, file bookmark, dsb.
    static let directoryNameMain = "myapp"
    
    /// App temp directory name
    /// Biasanya digunakan untuk menyimpan file draft.
    /// Sebaiknya isi folder ini dihapus pada waktu tertentu untuk menyimpan space.
    static let directoryNameTemp = "myapp-temp"
    
    /// App document directory url
    static var documentDirectory: URL {
        return NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!) as URL
    }
    
    /// App main directory url
    static var mainDirectory: URL {
        let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        return documentDirectory.appendingPathComponent(directoryNameMain)!
    }
    
    /// App temp directory url
    static var tempDirectory: URL {
        let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        return documentDirectory.appendingPathComponent(directoryNameTemp)!
    }
    
    /// App system temp directory url
    static var systemTempDirectory: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    // MARK: Operation file
    
    static func protectFile(at url: URL) {
        do {
            try FileManager.default.setAttributes([.protectionKey: FileProtectionType.complete], ofItemAtPath: url.path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func copyFile(from source: URL, to destination: URL, replace: Bool = false) -> URL? {
        if replace {
            _ = removeFile(at: destination)
        }
        
        do {
            try FileManager.default.copyItem(at: source, to: destination.appendingPathComponent(source.lastPathComponent))
            return destination
        } catch {
            print("Failed to copy file: \(error.localizedDescription)")
        }
        return nil
    }
    
    @discardableResult static func removeFile(at source: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: source)
            return true
        } catch {
            print("Failed to remove file: \(error.localizedDescription)")
        }
        return false
    }
    
    static func moveFile(at source: URL, to destination: URL, replace: Bool = false) -> URL? {
        if replace {
            _ = removeFile(at: destination)
        }
        
        do {
            try FileManager.default.moveItem(at: source, to: destination)
            return destination
        } catch {
            print("Failed to move file: \(error.localizedDescription)")
        }
        return nil
    }
    
    /// Create and protect directory if needed.
    static func createDirectory(at destination: URL) -> URL? {
        if !FileManager.default.fileExists(atPath: destination.relativePath) {
            do {
                try FileManager.default.createDirectory(atPath: destination.relativePath, withIntermediateDirectories: true, attributes: nil)
                protectFile(at: destination)
                return destination
            } catch let error as NSError {
                print("Unable to create directory \(error.debugDescription)")
                return nil
            }
        }
        return destination
    }
    
    // MARK: Move File
    
    /// Move file to app local main directory
    static func moveFileToLocalMain(from source: URL, replace: Bool = true) -> URL? {
        guard let mainDirectory = createDirectory(at: mainDirectory) else { return nil }
        
        let fileName = source.lastPathComponent
        let destinationUrl = mainDirectory.appendingPathComponent(fileName)
        return moveFile(at: source, to: destinationUrl, replace: replace)
    }
    
    /// Move file to app local temporary directory
    static func moveFileToLocalTemp(from source: URL, replace: Bool = true) -> URL? {
        guard let tempDirectory = createDirectory(at: tempDirectory) else { return nil }
        
        let fileName = source.lastPathComponent
        let destinationUrl = tempDirectory.appendingPathComponent(fileName)
        return moveFile(at: source, to: destinationUrl, replace: replace)
    }
    
    /// Move file to app system temporary directory. The system will remove them at any time.
    static func moveFileToSystemTemp(from source: URL, replace: Bool = true) -> URL? {
        let fileName = source.lastPathComponent
        let destinationUrl = systemTempDirectory.appendingPathComponent(fileName)
        return moveFile(at: source, to: destinationUrl, replace: replace)
    }
    
    // MARK: Copy File
    
    /// Copy file to app local main directory
    static func copyFileToLocalMain(from source: URL, replace: Bool = true) -> URL? {
        guard let mainDirectory = createDirectory(at: mainDirectory) else { return nil }
        
        let fileName = source.lastPathComponent
        let destinationUrl = mainDirectory.appendingPathComponent(fileName)
        return copyFile(from: source, to: destinationUrl, replace: replace)
    }
    
    /// Copy file to app local temporary directory
    static func copyFileToLocalTemp(from source: URL, replace: Bool = true) -> URL? {
        guard let tempDirectory = createDirectory(at: tempDirectory) else { return nil }
        
        let fileName = source.lastPathComponent
        let destinationUrl = tempDirectory.appendingPathComponent(fileName)
        return copyFile(from: source, to: destinationUrl, replace: replace)
    }
    
    /// Copy file to app system temporary directory. The system will remove them at any time.
    static func copyFileToSystemTemp(from source: URL, replace: Bool = true) -> URL? {
        let fileName = source.lastPathComponent
        let destinationUrl = systemTempDirectory.appendingPathComponent(fileName)
        return copyFile(from: source, to: destinationUrl, replace: replace)
    }
    
    // MARK: Accessing file
    
    /// Get file url at document directory if exists.
    /// - Parameter path: filename or filepath (for deeper location).
    /// - Returns: file URL.
    static func documentFile(path: String) -> URL? {
        let filePath = documentDirectory.appendingPathComponent(path)
        if FileManager.default.fileExists(atPath: filePath.path) {
            return filePath
        }
        return nil
    }
    
    static func exists(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
}
