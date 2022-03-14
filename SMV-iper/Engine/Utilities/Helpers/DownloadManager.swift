//
//  DownloadManager.swift
//
//
//  Created by Rifat Firdaus on 9/23/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

struct MyDownloadedFile {
    var title = ""
    var url:URL
    var fileSize: Int64 = 0
    
    init(title: String = "", url: URL, fileSize: Int64 = 0) {
        self.title = title
        self.url = url
        self.fileSize = fileSize
    }
}

class DownloadManager: NSObject {
    
    // static let instance = DownloadManager()
    
    // private var url:NSURL?
    
    //MARK: METHODS
    
    static func filenameWithUrlString(_ urlString: String) -> String? {
        guard let thisUrl = URL(string: urlString) else {
            return "-"
        }
        return thisUrl.lastPathComponent
    }
    
    static func filenameExtensionWithUrlString(_ urlString: String) -> String? {
        guard let thisUrl = URL(string: urlString) else {
            return "-"
        }
        return thisUrl.lastPathComponent + "." + thisUrl.pathExtension
    }
    
    static func extensionWithUrlString(_ urlString: String) -> String? {
        guard let thisUrl = URL(string: urlString) else {
            return "-"
        }
        return thisUrl.pathExtension
    }
    
    static func imageExtensionWithUrlString(_ urlString: String) -> UIImage {
        guard let thisUrl = URL(string: urlString) else {
            return UIImage()
        }
        if thisUrl.pathExtension != "" {
            if let imageIcon = UIImage(named: "ic_\(thisUrl.pathExtension.lowercased())") {
                return imageIcon
            } else {
                return UIImage(named: "img_placeholder_thumbnail")!
            }
        }
        return UIImage()
    }
    
    static func urlInDocumentsDirectory(_ urlString: String) -> URL? {
        guard let _ = URL(string: urlString) else {
            return nil
        }
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            let path = paths[0]
            if let directory = URL(string: path), let filename = self.filenameWithUrlString(urlString) {
                let fileURL = directory.appendingPathComponent(filename)
                return fileURL
            }
        }
        return nil
    }
    
    static func documentsDirectoryFiles() -> [MyDownloadedFile?]? {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory( at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            let filteredFiles = directoryContents.filter{ file in
                if file.pathExtension == "pdf" {
                    return true
                } else if file.pathExtension == "doc" {
                    return true
                } else if file.pathExtension == "docx" {
                    return true
                } else if file.pathExtension == "xls" {
                    return true
                } else if file.pathExtension == "xlsx" {
                    return true
                } else if file.pathExtension == "ppt" {
                    return true
                } else if file.pathExtension == "pptx" {
                    return true
                }
                return false
            }
            
//            let namedFiles = filteredFiles.flatMap({$0.URLByDeletingPathExtension?.lastPathComponent})
            var files = [MyDownloadedFile?]()

            for file in filteredFiles {
//                files.append([file.lastPathComponent:file])
//                files.append(MyDownloadedFile(title: file.lastPathComponent, url: file, fileSize: file.file)
                do {
                    let resources = try file.resourceValues(forKeys:[.fileSizeKey])
                    let fileSize = resources.fileSize ?? 0
//                    let realm = try! Realm()
//                    let result = realm.objects(Attachment.self).filter("file LIKE '*\(file.lastPathComponent.replacingOccurrences(of: " ", with: "%20"))'").first
                    files.append(MyDownloadedFile(title: file.lastPathComponent, url: file, fileSize: Int64(fileSize)))
                } catch {
                    print("Error: \(error)")
                }
            }
            return files
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func downloadFile(_ urlString: String, headers: HTTPHeaders? = nil, completionHandler: @escaping (Double?, Error?, URL?) -> Void) {
        guard let _ = URL(string: urlString) else {
            completionHandler(nil, NSError(domain: "Invalid URL", code: 10, userInfo: nil), nil)
            return
        }
        
        guard isChartDownloaded(urlString) == false else {
            print("[Downloaded!]")
            completionHandler(1.0, nil, urlInDocumentsDirectory(urlString))
            return
        }
        
        Alamofire.download(urlString, method: .get, headers: headers, to: { temporaryURL, response in
            let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if !directoryURLs.isEmpty {
                return (directoryURLs[0].appendingPathComponent(response.suggestedFilename!), [.removePreviousFile])
            }
            return (temporaryURL, [.removePreviousFile])
        })
            .downloadProgress { progress in
                let progressString = String(format: "⏩ [Progress %.0f%%]", progress.fractionCompleted * 100)
                print(progressString)
                if progress.fractionCompleted < 1.0 {
                    completionHandler(progress.fractionCompleted, nil, self.urlInDocumentsDirectory(urlString))
                }
            }.responseString { (response) in
                print(response.result)
                if response.error != nil {
                    completionHandler(nil, response.error! as NSError, self.urlInDocumentsDirectory(urlString))
                } else {
                    completionHandler(1.0, nil, response.destinationURL)
                }
            }
    }
    
    static func isChartDownloaded(_ urlString: String) -> Bool {
        if let url = self.urlInDocumentsDirectory(urlString), url.path != "" {
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: url.path)
        }
        return false
    }
    
    
    static func fileSizeStringWithUrlString(_ urlString: String) -> UInt64 {
//        if let url = self.urlInDocumentsDirectory(urlString) {
            let filePath = self.urlInDocumentsDirectory(urlString)!.absoluteString
            var fileSize : UInt64 = 0
            do {
                let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
                if let _attr = attr {
                    fileSize = _attr.fileSize();
                }
            } catch {
                print("Error: \(error)")
            }
            return fileSize
//        }
//        return requestFileSize(urlString, completionHandler: { (fileSize, error) in
//            return completionHandler(fileSize)
//        })
    }
    
    static func requestFileSize(_ urlString:String, completionHandler: @escaping (UInt64, NSError?) -> Void) {
        Alamofire.request(urlString, method: .get).responseData { (response) in
            if let data = response.data {
                return completionHandler(UInt64(data.count), nil)
            }
            return completionHandler(0, response.result.error! as NSError)
        }
//        Alamofire.request(.GET, urlString)
//        .responseData { response in
//            if let data = response.data {
//                return completionHandler(UInt64(data.length), nil)
//            }
//            return completionHandler(0, response.result.error)
//        }
    }
    
}
