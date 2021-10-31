//
//  WelcomeViewController.swift
//  keyChainLoginApp
//
//  Created by Konstantin on 28.10.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var dynamicUserNameLabel: UILabel!
    @IBOutlet weak var userCredentials: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    var userGreetinLabel: String = ""
    var userCred: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.cornerRadius = 10
        dynamicUserNameLabel.text = "User: \(userGreetinLabel)"
        userCredentials.text = "Your password is: \(userCred)"
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
}

