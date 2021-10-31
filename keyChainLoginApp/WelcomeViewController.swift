//
//  WelcomeViewController.swift
//  keyChainLoginApp
//
//  Created by Konstantin on 28.10.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var dynamicUserNameLabel: UILabel!
    @IBOutlet weak var dynamicPasswordLabel: UILabel!
    @IBOutlet weak var userCredentials: UILabel!
    
    var userGreetinLabel: String = ""
    var userPasswordLabel: String = ""
    var userCred: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicUserNameLabel.text = "User: \(userGreetinLabel)"
        dynamicPasswordLabel.text = ""
        userCredentials.text = "Your password is: \(userCred)"
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
}

