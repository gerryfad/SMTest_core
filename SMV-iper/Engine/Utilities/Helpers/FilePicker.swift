//
//  FilePicker.swift
//  CommHub
//
//  Created by Alam Akbar Muhammad on 20/03/19.
//  Copyright © 2019 Suitmedia. All rights reserved.
//
//  Credit: deepakraj27 (https://gist.github.com/deepakraj27/2b5066c488c38d8456678297b17e0bea)

import MobileCoreServices
import Foundation
import AVFoundation
import Photos
import SwiftDate

class FilePicker: NSObject {
    struct Constants {
        static let actionFileTypeHeading = "Browse file"
        static let actionFileTypeDescription: String? = nil
        static let camera = "Camera"
        static let photoLibrary = "Photos"
        static let video = "Video"
        static let document = "Files"
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
    }
    
    typealias SuccessCallback = ((_ attachmentType: AttachmentType, _ url: URL, _ image: UIImage?) -> Void)
    typealias FailedCallback = ((_ attachmentType: AttachmentType, _ error: Error) -> Void)
    private var onSuccess: SuccessCallback?
    private var onFailed: FailedCallback?
    
    /// Image jpeg compression quality 0.0 ... 1.0
    var imageCompressionQuality: CGFloat = 1.0
    
    /// Video compression quality. Examples: AVAssetExportPreset640x480, and more...
    var videoCompressionQuality: String = AVAssetExportPresetMediumQuality
    
    var documentMediaTypes = [String(kUTTypeItem)]
    var photoMediaTypes = [String(kUTTypeImage)]
    var videoMediaTypes = [String(kUTTypeMovie), String(kUTTypeVideo)]
    
    static let shared = FilePicker()
    fileprivate var parentController: UIViewController?
    
    enum AttachmentType {
        case camera, photo, document, video
        
        static let all: [AttachmentType] = [.camera, .photo, .video, .document]
    }
    
    func show(_ target: UIViewController, onSuccess: SuccessCallback?, onFailed: FailedCallback? = nil, sourceView popOverSourceView: UIView? = nil, types: [AttachmentType] = AttachmentType.all) {
        parentController = target
        self.onSuccess = onSuccess
        self.onFailed = onFailed
        
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        if types.contains(.camera) {
            actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { [weak self] (action) -> Void in
                self?.authorizationStatus(attachmentTypeEnum: .camera)
            }))
        }
        if types.contains(.photo) {
            actionSheet.addAction(UIAlertAction(title: Constants.photoLibrary, style: .default, handler: { [weak self] (action) -> Void in
                self?.authorizationStatus(attachmentTypeEnum: .photo)
            }))
        }
        if types.contains(.video) {
            actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { [weak self] (action) -> Void in
                self?.authorizationStatus(attachmentTypeEnum: .video)
            }))
        }
        if types.contains(.document) {
            actionSheet.addAction(UIAlertAction(title: Constants.document, style: .default, handler: { [weak self] (action) -> Void in
                self?.documentPicker()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            let view: UIView = popOverSourceView ?? target.view
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        parentController?.present(actionSheet, animated: true, completion: nil)
    }
    
    private func authorizationStatus(attachmentTypeEnum: AttachmentType){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera {
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photo {
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video {
                videoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
                if status == PHAuthorizationStatus.authorized {
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera {
                        self?.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photo {
                        self?.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video {
                        self?.videoLibrary()
                    }
                } else{
                    print("restriced manually")
                    self?.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    // MARK: CAMERA PICKER
    
    func openCamera() {
        DispatchQueue.main.async { [weak self] in
            self?.openCameraInternal()
        }
    }
    
    private func openCameraInternal(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.navigationBar.isTranslucent = false
            //myPickerController.navigationBar.barTintColor = #colorLiteral(red: 0.04705882353, green: 0.5098039216, blue: 0.7333333333, alpha: 1)
            //myPickerController.navigationBar.tintColor = .white
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeImage as String]
            parentController?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: PHOTO PICKER
    
    func photoLibrary() {
        DispatchQueue.main.async { [weak self] in
            self?.photoLibraryInternal()
        }
    }
    
    private func photoLibraryInternal(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.navigationBar.isTranslucent = false
            //myPickerController.navigationBar.barTintColor = #colorLiteral(red: 0.04705882353, green: 0.5098039216, blue: 0.7333333333, alpha: 1)
            //myPickerController.navigationBar.tintColor = .white
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = photoMediaTypes
            parentController?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: VIDEO PICKER
    
    func videoLibrary() {
        DispatchQueue.main.async { [weak self] in
            self?.videoLibraryInternal()
        }
    }
    
    private func videoLibraryInternal(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.navigationBar.isTranslucent = false
            //myPickerController.navigationBar.barTintColor = #colorLiteral(red: 0.04705882353, green: 0.5098039216, blue: 0.7333333333, alpha: 1)
            //myPickerController.navigationBar.tintColor = .white
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = videoMediaTypes
            parentController?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: FILE PICKER
    
    func documentPicker() {
        DispatchQueue.main.async { [weak self] in
            self?.documentPickerInternal()
        }
    }
    
    private func documentPickerInternal() {
        // let docTypes = [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)]
        let importMenu = UIDocumentPickerViewController(documentTypes: documentMediaTypes, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        parentController?.present(importMenu, animated: true, completion: nil)
    }
    
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType) {
        DispatchQueue.main.async { [weak self] in
            self?.addAlertForSettingsInternal(attachmentTypeEnum)
        }
    }
    
    private func addAlertForSettingsInternal(_ attachmentTypeEnum: AttachmentType) {
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera {
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photo {
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video {
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController(title: alertTitle , message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
        
        cameraUnavailableAlertController.addAction(cancelAction)
        cameraUnavailableAlertController.addAction(settingsAction)
        parentController?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
}

extension FilePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.parentController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let imageName = NSUUID().uuidString + ".jpg";
            let photoURL = NSURL(fileURLWithPath: documentDirectory)
            let localPath = photoURL.appendingPathComponent(imageName)
            
            if let localPath = localPath {
                do {
                    // quality lowest-highest: 0-1
                    var data = image.jpegData(compressionQuality: 1.0)
                    if imageCompressionQuality != 1.0 {
                        print("FilePicker image: before compression \(data?.count ?? 0) bytes")
                        data = image.jpegData(compressionQuality: imageCompressionQuality)
                        print("FilePicker image: after compression \(data?.count ?? 0) bytes")
                    }
                    
                    try data?.write(to: localPath, options: Data.WritingOptions.atomic)
                    print("FilePicker image: \(localPath)")
                    
                    self.onSuccess?(AttachmentType.photo, localPath, image)
                }
                catch {
                    self.onFailed?(AttachmentType.photo, NSError(domain: "FilePicker", code: 1, userInfo: [NSLocalizedDescriptionKey: "FilePicker image: failed. \(error.localizedDescription)"]))
                }
            } else {
                let error = NSError(domain: "FilePicker", code: 1, userInfo: [NSLocalizedDescriptionKey: "FilePicker image: failed. Invalid localPath."])
                print(error.localizedDescription)
                self.onFailed?(AttachmentType.photo, error)
            }
        } else if let videoUrl = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? NSURL {
            // trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("FilePicker video: file size before compression: \(Double(data.length / 1048576)) MB")
            compressWithSessionStatusFunc(videoUrl)
        } else {
            let error = NSError(domain: "FilePicker", code: 1, userInfo: [NSLocalizedDescriptionKey: "FilePicker: failed. Unknown."])
            print(error.localizedDescription)
            self.onFailed?(AttachmentType.photo, error)
        }
        
        parentController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { [weak self] (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("FilePicker video: file size after compression: \(Double(compressedData.length / 1048576)) MB")
                print("FilePicker video: ", videoUrl)
                
                DispatchQueue.main.async {
                    self?.onSuccess?(AttachmentType.video, compressedURL, nil)
                }
            case .failed:
                DispatchQueue.main.async {
                    let error = NSError(domain: "FilePicker", code: 1, userInfo: [NSLocalizedDescriptionKey: "FilePicker video: failed. \(session.error?.localizedDescription ?? "Unknown error")"])
                    print(error.localizedDescription)
                    self?.onFailed?(AttachmentType.video, error)
                }
            default:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler: @escaping(_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: videoCompressionQuality) else {
            handler(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

extension FilePicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            self.onFailed?(AttachmentType.document, ErrorHelper.instance.create("Url not found", 31))
            return
        }
        print("FilePicker document: ", url)
        self.onSuccess?(AttachmentType.document, url, nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
