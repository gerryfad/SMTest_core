//
//  ProfilePresenter.swift
//  SMV-iper
//
//  Created by Alam Akbar Muhammad on 08/08/19.
//  Copyright © 2019 Rifat Firdaus. All rights reserved.
//

import RealmSwift
import RxSwift

protocol ProfilePresenterProtocol: BaseProtocol {
    func uploading(percentage: Double)
}

class ProfilePresenter: BasePresenter<Object> {
    
    weak var view: ProfilePresenterProtocol?
    
    func editProfile() {
        let filePath = Bundle.main.path(forResource: "image_big", ofType: "jpg")!
        // let fileLocalUrl = URL(fileURLWithPath: filePath)
        let imageProfile = UIImage(contentsOfFile: filePath)!
        let profileData = ProfileApi.Create(
            token: "dfcfe690806d3b57433814a9d301eb71",
            password: nil,
            password_confirm: nil,
            current_password: nil,
            name: "Alam Ma",
            phone_number: "0101010101",
            // picture: fileLocalUrl
            picture: imageProfile
            // pictures: [imageProfile, imageProfile]
        )
        ProfileApi.edit(profileData)
            .do(onNext: { (fractionCompleted, json) in
                print("upload status  : \(json != nil) \(fractionCompleted * 100)")
                if fractionCompleted < 1.0 {
                    // do something
                } else {
                    print("uploadProgress : \(json != nil) completed \n\(String(describing: json))")
                }
                self.view?.uploading(percentage: fractionCompleted)
            })
            .compactMap { $0.1 }
            .mapAPIResponse()
            .validateSuccess()
            .do(onNext: { _ in
                self.view?.showData()
            })
            .do(onError: { error in
                self.view?.showError(error: error)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
