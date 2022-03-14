//
//  FirstViewController.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var presenter: FirstPresenter!

    let imageViewBackground: UIImageView = {
        let imageViewBackgroundImage = UIImageView(frame: UIScreen.main.bounds)
        imageViewBackgroundImage.image = UIImage(named: "background")
        imageViewBackgroundImage.contentMode = .scaleToFill
     return imageViewBackgroundImage
    }()
    
    let imageViewAddPhote: UIImageView = {
        let image = UIImage(named: "btn_add_photo ")
        let imageViewAddPhote = UIImageView(image: image)
        imageViewAddPhote.translatesAutoresizingMaskIntoConstraints = false
        return imageViewAddPhote
    }()
    
    let textFieldName: UITextField = {
        let textFieldName = UITextField()
        textFieldName.placeholder = "Name"
        textFieldName.backgroundColor = .white
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        return textFieldName
    }()
    
    let textFieldPalindrome: UITextField = {
        let textFieldPalindrome = UITextField()
        textFieldPalindrome.placeholder = "Palindrome"
        textFieldPalindrome.backgroundColor = .white
        textFieldPalindrome.borderStyle = .roundedRect
        textFieldPalindrome.translatesAutoresizingMaskIntoConstraints = false
        return textFieldPalindrome
    }()
    
    let buttonCheck: UIButton = {
        let buttonCheck = UIButton()
        buttonCheck.setTitle("CHECK", for: .normal)
        buttonCheck.backgroundColor = .blue
        buttonCheck.setTitleColor(.white, for: .normal)
        buttonCheck.layer.cornerRadius = 5
        buttonCheck.translatesAutoresizingMaskIntoConstraints = false
        buttonCheck.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        return buttonCheck
    }()
    
    @objc func handleCheck() {
        presenter.showIsPalindrome(word: textFieldPalindrome.text ?? "", target: self)
    }
    
    let buttonNext: UIButton = {
        let buttonNext = UIButton()
        buttonNext.setTitle("NEXT", for: .normal)
        buttonNext.backgroundColor = .blue
        buttonNext.setTitleColor(.white, for: .normal)
        buttonNext.layer.cornerRadius = 5
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return buttonNext
    }()
    
    @objc func handleNext() {
//        let vc = SecondViewController(name: nameField.text ?? "")
//
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true)
        
        let vc = UINavigationController(rootViewController: SecondViewController())
        presentToSecondView(name: textFieldName.text ?? "")
    }
    

    lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.buttonCheck, self.buttonNext].forEach{ stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var textFieldStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [ self.textFieldName,self.textFieldPalindrome].forEach{ stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.imageViewAddPhote,self.textFieldStack,self.buttonStack] .forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.insertSubview(imageViewBackground, at: 0)
        view.addSubview(rootStackView)
    
       
        setupLayout()
    }
    
    private func setupLayout(){
        
        
        
        NSLayoutConstraint.activate([
            
            rootStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rootStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         
            imageViewAddPhote.widthAnchor.constraint(equalToConstant: 120),
            imageViewAddPhote.heightAnchor.constraint(equalToConstant: 120),
            
            textFieldName.widthAnchor.constraint(equalToConstant:  300),
            textFieldName.heightAnchor.constraint(equalToConstant: 50),
            
            textFieldPalindrome.widthAnchor.constraint(equalToConstant: 300),
            textFieldPalindrome.heightAnchor.constraint(equalToConstant: 50),
            
            buttonCheck.widthAnchor.constraint(equalToConstant: 300),
            buttonCheck.heightAnchor.constraint(equalToConstant: 40),
            
            buttonNext.widthAnchor.constraint(equalToConstant: 300),
            buttonNext.heightAnchor.constraint(equalToConstant: 40)
            
            
            
        ])
    }

}

extension FirstViewController: FirstPresenterProtocol{
    func showData() {
        
    }
    
    func showError(error: Error?) {
        
    }
    
}

// MARK: - Router

extension FirstViewController {
    static func instantiate() -> FirstViewController {
        let view = FirstViewController()
        let presenter = FirstPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    static func instantiateNav() -> UINavigationController {
        let view = instantiate()
        return ViewManager.createNavigationController(rootController: view)
    }
    
    
func presentToSecondView(name: String) {
        let view = SecondViewController.instantiateNav(name: name)
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
}
