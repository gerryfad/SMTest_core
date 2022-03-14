// swiftlint:disable all
//
//  SMEngineService.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 10/1/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import Alamofire
import RxAlamofire
import SwiftyJSON
import RxSwift

public typealias Headers = [String: String]

open class SMEngineService: NSObject {
    
    public static let instance = SMEngineService()
    
    public let manager = SMEngineManager()
    public let successCode = 1
    public let headers: () -> Headers = SMCoreConfig.headers
    
    /// Base http request. Path can be overriden by providing full url with scheme.
    /// Headers can be overriden by providing non-nil.
    func request(_ method: HTTPMethod, _ path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<(HTTPURLResponse, Any)> {
        let overridenHeaders = headers ?? self.headers()
        let overridenUrl = path.hasPrefix("http") ? path : BaseURL.apiUrl + path
        return manager.requestJSON(method, overridenUrl, parameters: parameters, encoding: encoding, headers: overridenHeaders)
    }
    
    /// Request will return JSON
    func requestJson(method: HTTPMethod, path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<JSON> {
        return request(method, path, parameters: parameters, encoding: encoding, headers: headers)
            .mapJson()
    }
    
    /// Request upload with expected return JSON
    func upload(method: HTTPMethod, path: String, headers: Headers? = nil, data: @escaping (MultipartFormData) -> Void) -> Observable<(Double, JSON?)> {
        let overridenHeaders = headers ?? self.headers()
        let overridenUrl = path.hasPrefix("http") ? path : BaseURL.apiUrl + path
        return manager.encodeMultipartUpload(to: overridenUrl, method: method, headers: overridenHeaders, data: data)
            .flatMap({ request in
                return Observable.create({ (observer) -> Disposable in
                    observer.onNext((request.uploadProgress.fractionCompleted, nil))
                    request.uploadProgress(closure: { progress in
                        if progress.fractionCompleted < 1.0 {
                            observer.onNext((progress.fractionCompleted, nil))
                        }
                    })
                    request.responseJSON(completionHandler: { response in
                        switch response.result {
                        case let .success(value):
                            let json = JSON(value)
                            observer.onNext((request.uploadProgress.fractionCompleted, json))
                            observer.onCompleted()
                        case let .failure(error):
                            observer.onError(error)
                        }
                    })
                    return Disposables.create()
                })
            })
    }
    
    /// Request will return JSON converted to Object
    func object<T: Parseable>(method: HTTPMethod, path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<T> {
        return requestJson(method: method, path: path, parameters: parameters, encoding: encoding, headers: headers)
            .mapObject(T.self)
    }

    /// Request will return JSON converted to array of Object
    func objects<T: Parseable>(method: HTTPMethod, path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<[T]> {
        return requestJson(method: method, path: path, parameters: parameters, encoding: encoding, headers: headers)
            .mapObjects(T.self)
    }
    
    /// Request will return APIResponse with code success
    func response(method: HTTPMethod, path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<APIResponse> {
        return request(method, path, parameters: parameters, encoding: encoding, headers: headers)
            .mapAPIResponse()
            .validateTokenExpired()
            .validateSuccess()
    }
    
    /// Request will return APIResponse converted to Object if success
    func responseObject<T: Parseable>(method: HTTPMethod, path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<T> {
        return response(method: method, path: path, parameters: parameters, encoding: encoding, headers: headers)
            .mapResponseObject(T.self)
            .friendlyError()
    }
    
    /// Request will return APIResponse converted to array of Object if success
    func responseObjects<T: Parseable>(method: HTTPMethod, path: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<[T]> {
        return response(method: method, path: path, parameters: parameters, encoding: encoding, headers: headers)
            .mapResponseObjects(T.self)
            .friendlyError()
    }
    
    /// Request will return APIResponse converted to Pagination if success
    func responsePagination<T: Parseable>(method: HTTPMethod, path: String, page: Int, perPage: Int, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: Headers? = nil) -> Observable<Pagination<[T]>> {
        var overridenParameters = PageStatus.RequestKey(page, perPage).dictionary()
        overridenParameters?.update(dictionary: parameters)
        return response(method: method, path: path, parameters: overridenParameters, encoding: encoding, headers: headers)
            .mapResponsePagination(T.self)
            .friendlyError()
    }
    
}

// MARK: - Authorization Header

struct Authorization {
    struct Key {
        static let authorization = "Authorization"
    }
    
    static func bearer(_ token: String?) -> Headers {
        guard let token = token else { return [:] }
        return [
            Key.authorization: "Bearer \(token)"
        ]
    }
    
    static func basic(_ username: String?, _ password: String?) -> Headers {
        guard let username = username, let password = password else { return [:] }
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return [
            Key.authorization: "Basic \(base64LoginString)"
        ]
    }
}

// MARK: - Session Manager

public class SMEngineManager: SessionManager {
    
    override public func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        do {
            let urlRequest = URLRequest(url: try url.asURL())
            let request = try! encoding.encode(urlRequest, with: parameters)
            print("[\(method.rawValue)] \(request)")
        } catch {
            print("🚫 Error URL Request")
        }
        return super.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    public func requestJSON(_ method: Alamofire.HTTPMethod,
                            _ url: URLConvertible,
                            parameters: [String: Any]? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            headers: [String: String]? = nil)
        -> Observable<(HTTPURLResponse, Any)>
    {
        var requestString = ""
        do {
            let urlRequest = URLRequest(url: try url.asURL())
            let request = try! encoding.encode(urlRequest, with: parameters)
            requestString = "➡️ [\(method.rawValue)] \(request)"
            print(requestString)
        } catch {
            print("🚫 Error URL Request")
        }
        return SessionManager.default.rx.responseJSON(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
            .do(onError: { error in
                throw ErrorHelper.instance.create(code: ErrorCode.alamofire.rawValue,
                                                  message: error.localizedDescription,
                                                  info: requestString)
            })
    }
    
    public func encodeMultipartUpload(to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders = [:], data: @escaping (MultipartFormData) -> Void) -> Observable<UploadRequest> {
        do {
            let urlRequest = URLRequest(url: try url.asURL())
            print("➡️ [\(method.rawValue)] \(urlRequest)")
        } catch {
            print("🚫 Error URL Request")
        }
        return Observable.create { observer in
            self.upload(multipartFormData: data,
                        to: url,
                        method: method,
                        headers: headers,
                        encodingCompletion: { (result: SessionManager.MultipartFormDataEncodingResult) in
                            switch result {
                            case .failure(let error):
                                observer.onError(error)
                            case .success(let request, _, _):
                                observer.onNext(request)
                                observer.onCompleted()
                            }
            })
            
            return Disposables.create()
        }
    }
}

// MARK: - Reflectionable

protocol Reflectionable {}
extension Reflectionable {
    func dictionary(snakeCased: Bool = false) -> [String: Any]? {
        let otherSelf = Mirror(reflecting: self)
        guard !otherSelf.children.isEmpty else { return nil }
        var dict = [String: Any]()
        for child in otherSelf.children {
            let value = unwrap(child.value)
            if let key = child.label {
                if snakeCased, let key = key.snakeCased() {
                    dict[key] = value
                } else {
                    dict[key] = value
                }
            }
        }
        return dict
    }
}

// MARK: - Multipartable

enum ImageType: String {
    case jpg = "jpg"
    case png = "png"
    
    var mimeType: String {
        switch self {
        case .jpg:
            return "image/jpg"
        case .png:
            return "image/png"
        }
    }
}

protocol Multipartable: Reflectionable {
    func imageType() -> ImageType
    func imageTypes() -> [String: ImageType]?
    func imageCompression() -> CGFloat
    func imageCompressions() -> [String: CGFloat]?
    func fileNames() -> [String: String]?
    var asMultipartFormDataClosure: (MultipartFormData) -> Void { get }
}

extension Multipartable {
    /// Default image type is jpg.
    func imageType() -> ImageType {
        return .jpg
    }
    
    /// Define image type per specific key
    func imageTypes() -> [String: ImageType]? {
        return nil
    }
    
    /// Default image compression (worst 0.0 - 1.0 best). Only works for jpg.
    func imageCompression() -> CGFloat {
        return 1.0
    }
    
    /// Define image compression per specific key
    func imageCompressions() -> [String: CGFloat]? {
        return nil
    }
    
    /// Define image filename per specific key.
    /// Key with type array will have extra number behind (pictures-0, pictures-1, pictures-2, ...)
    func fileNames() -> [String: String]? {
        return nil
    }
    
    /// Generate multipartformdata.
    var asMultipartFormDataClosure: (MultipartFormData) -> Void {
        return { data in
            guard let dict = self.dictionary()?.compactMap() else { return }
            
            for (key, value) in dict {
                if let value = value as? URL {
                    data.append(value, withName: key)
                } else if let values = value as? [URL] {
                    var i = 0
                    values.forEach({ item in
                        data.append(item, withName: "\(key)[\(i)]")
                        i += 1
                    })
                } else if let value = value as? UIImage {
                    if let imageData = self.data(of: value, key: key) {
                        data.append(imageData.data, withName: key, fileName: imageData.fileName, mimeType: imageData.mimeType)
                    }
                } else if let values = value as? [UIImage] {
                    var i = 0
                    values.forEach({ item in
                        if let imageData = self.data(of: item, key: key, fileNameSuffix: "-\(i)") {
                            data.append(imageData.data, withName: key + "[\(i)]", fileName: imageData.fileName, mimeType: imageData.mimeType)
                            i += 1
                        }
                    })
                } else if let dataValue = "\(value)".data(using: .utf8) {
                    data.append(dataValue, withName: key)
                } else {
                    print("[\(key): \(value) of type \(type(of: value))] not supported.")
                }
            }
        }
    }
    
    private func data(of image: UIImage, key: String, fileNameSuffix: String = "") -> (data: Data, fileName: String, mimeType: String)? {
        let imageType = self.imageTypes()?[key] ?? self.imageType()
        let fileName = (self.fileNames()?[key] ?? key) + "\(fileNameSuffix).\(imageType.rawValue)"
        switch imageType {
        case .jpg:
            if let data = image.jpegData(compressionQuality: self.imageCompressions()?[key] ?? self.imageCompression()) {
                return (data: data, fileName: fileName, mimeType: imageType.mimeType)
            }
        case .png:
            if let data = image.pngData() {
                return (data: data, fileName: fileName, mimeType: imageType.mimeType)
            }
        }
        return nil
    }
}

// MARK: - Utility

func unwrap<T>(_ any: T) -> Any {
    let mirror = Mirror(reflecting: any)
    guard mirror.displayStyle == .optional, let first = mirror.children.first else {
        return any
    }
    return first.value
}

extension String {
    func snakeCased() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
}

fileprivate protocol OptionalProtocol {}
extension Optional: OptionalProtocol {}
extension Dictionary {
    /// filter non-nil values
    func compactMap() -> Dictionary<Key, Value> {
        return filter{ !($0.value is OptionalProtocol) }
    }
}
