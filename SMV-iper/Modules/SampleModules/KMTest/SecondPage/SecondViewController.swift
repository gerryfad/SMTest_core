//
//  SecondViewController.swift
//  SMV-iper
//
//  Created by yaelahbro on 12/03/22.
//  Copyright © 2022 Rifat Firdaus. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var presenter: SecondPresenter!

    var name: String = ""
    
    
    let labelWelcome: UILabel = {
        let labelWelcome = UILabel()
        labelWelcome.text = "Welcome"
        labelWelcome.font = UIFont.systemFont(ofSize: 16)
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        return labelWelcome
    }()
    
    lazy var labelName: UILabel = {
        let labelName = UILabel()
        labelName.text = self.name
        labelName.font = UIFont.boldSystemFont(ofSize: 22)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }()
    
    let labelSelectedName: UILabel = {
        let labelSelectedName = UILabel()
        labelSelectedName.text = "Selected Username"
        labelSelectedName.font = UIFont.boldSystemFont(ofSize: 24)
        labelSelectedName.translatesAutoresizingMaskIntoConstraints = false
        return labelSelectedName
    }()
    
    let buttonNext: UIButton = {
        let buttonNext = UIButton()
        buttonNext.setTitle("Choose A User", for: .normal)
        buttonNext.backgroundColor = .blue
        buttonNext.setTitleColor(.white, for: .normal)
        buttonNext.layer.cornerRadius = 5
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return buttonNext
    }()
    
    @objc func handleNext(){
        presentToThirdView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Second Screen"
        configureItem()
        view.addSubview(labelWelcome)
        view.addSubview(labelName)
        view.addSubview(labelSelectedName)
        view.addSubview(buttonNext)
        
        setupLayout()
        
       
        
    }
    
    private func setupLayout(){
        
        
        
        NSLayoutConstraint.activate([
            
            labelWelcome.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3),
            labelWelcome.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            labelName.bottomAnchor.constraint(equalToSystemSpacingBelow: labelWelcome.bottomAnchor, multiplier: 4),
            labelName.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            labelSelectedName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelSelectedName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonNext.widthAnchor.constraint(equalToConstant: 300),
            buttonNext.heightAnchor.constraint(equalToConstant: 40),
            
            
            
        ])
    }
    
    func configureItem(){
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(handleCancel)
            )
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension SecondViewController: SecondPresenterProtocol , ThirdPresenterProtocol{
    func selectUser(select: String) {
        labelSelectedName.text = select
    }
    
    

    func showData() {
        
    }
    
    func showError(error: Error?) {
        
    }
    
    
}

// MARK: - Router

extension SecondViewController {
    static func instantiate(name: String) -> SecondViewController {
        let view = SecondViewController()
        view.name = name
        let presenter = SecondPresenter()
        view.presenter = presenter
        presenter.view = view
        ThirdPresenter.view = view
        return view
    }
    
    static func instantiateNav(name: String) -> UINavigationController {
        let view = instantiate(name: name)
        return UINavigationController(rootViewController: view)
    }
    
    func presentToThirdView() {
        let view = ThirdViewController.instantiate()
        navigationController?.pushViewController(view, animated: true)
    }
}
