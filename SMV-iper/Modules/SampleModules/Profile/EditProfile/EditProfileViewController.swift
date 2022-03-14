//
//  ProfileViewController.swift
//  SMV-iper
//
//  Created by Rifat Firdaus on 13/12/18.
//  Copyright © 2018 Rifat Firdaus. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0
import TPKeyboardAvoiding

class EditProfileViewController: UIViewController {

    @IBOutlet private weak var imageViewPhoto: UIImageView!
    @IBOutlet private weak var imageViewKTP: UIImageView!
    @IBOutlet private weak var imageViewKTPSelfie: UIImageView!
    @IBOutlet private weak var textFieldName: UITextField!
    @IBOutlet private weak var textFieldBirthDate: UITextField!
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPhone: UITextField!
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var viewContainerPhoto: UIView!
    @IBOutlet private weak var scrollViewMain: TPKeyboardAvoidingScrollView!
    
    var dateParam: String? = "1989-10-06"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(Asset.Assets.bgNavBig.image, for: UIBarMetrics.default)
        
        scrollViewMain.addPullToRefresh { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                self?.scrollViewMain.pullToRefreshView.stopAnimating()
            })
        }
        setupBackBarButtonItems()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.parent?.title = "Profile"
        
        view.layoutIfNeeded()
        imageViewPhoto.circlifyImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction private func buttonSavePressed(_ sender: UIButton) {
        SVProgressHUD.showSuccess(withStatus: "Success!")
    }
    
    func setupView() {
        textFieldName.placeholder = "Name"
        textFieldBirthDate.placeholder = "Birth Date"
        textFieldEmail.placeholder = "Email"
        textFieldPhone.placeholder = "Phone"
        
        textFieldBirthDate.delegate = self
        
        imageViewPhoto.isUserInteractionEnabled = true
        let tapPhoto = SMTapGesture(target: self, action: #selector(imageTapGesture))
        tapPhoto.tag = 1
        imageViewPhoto.addGestureRecognizer(tapPhoto)
        viewContainerPhoto.backgroundColor = SMUITheme.color.accent
        
        imageViewKTP.isUserInteractionEnabled = true
        let tapKTP = SMTapGesture(target: self, action: #selector(imageTapGesture))
        tapKTP.tag = 2
        imageViewKTP.addGestureRecognizer(tapKTP)
        imageViewKTP.backgroundColor = SMUITheme.color.accent
        
        imageViewKTPSelfie.isUserInteractionEnabled = true
        let tapSelfie = SMTapGesture(target: self, action: #selector(imageTapGesture))
        tapSelfie.tag = 3
        imageViewKTPSelfie.addGestureRecognizer(tapSelfie)
        imageViewKTPSelfie.backgroundColor = SMUITheme.color.accent
        
        textFieldName.setBottomLine(borderColor: SMUITheme.color.primary)
        textFieldBirthDate.setBottomLine(borderColor: SMUITheme.color.primary)
        textFieldEmail.setBottomLine(borderColor: SMUITheme.color.primary)
        textFieldPhone.setBottomLine(borderColor: SMUITheme.color.primary)
        
        textFieldPhone.keyboardType = .numberPad
        textFieldPhone.addDoneButtonOnKeyboard()
        
        textFieldName.text = "Trafalgar D Water Law"
        textFieldBirthDate.text = "6 Oktober 1989"
        textFieldEmail.text = "Torao@gmail.com"
        textFieldPhone.text = "+55 55009982"
        
    }
    
    @objc func imageTapGesture(_ sender: SMTapGesture) {
        ViewManager.showImagePickerSheetMenu(tag: sender.tag, controller: self, delegate: self)
    }
    
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldBirthDate {
            view.endEditing(true)
            ViewManager.showDatePicker(title: "Tanggal Lahir", textField: self.textFieldBirthDate, dateStringInit: dateParam, dateFormatData: "yyyy-MM-dd", locale: Locale(identifier: "id"), donePick: { [weak self] dateData, dateView, _  in
                self?.dateParam = dateData
                self?.textFieldBirthDate.text = dateView
                print(self?.dateParam ?? "")
            })
            return false
        }
        return true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if picker.view.tag == 1 {
            imageViewPhoto.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        } else if picker.view.tag == 2 {
            imageViewKTP.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        } else {
            imageViewKTPSelfie.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Router

extension EditProfileViewController {
    static func instantiate() -> EditProfileViewController {
        let view = EditProfileViewController(nibName: self.className(), bundle: nil)
        // let presenter = EditProfilePresenter()
        // view.presenter = presenter
        // presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view, transparent: true)
    }
}
