//
//  LoginViewController.swift
//  keyChainLoginApp
//
//  Created by Konstantin on 28.10.2021.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var passwordReminder: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
//    метод который сохраняет логин и пароль в кичейн
    private func submit() {
        guard
            let myPassword = passwordTextField.text, !myPassword.isEmpty,
            let myUsername = userNameTextField.text, !myUsername.isEmpty
        else {
            return
        }
        
        let passwordData = Data(myPassword.utf8)

        keyChainClass.save(key: myUsername, data: passwordData)
    }
    
//    implementation of unwind segue in the destination VC
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
//    functions neede to shift the contents of the screen when keyboard appears
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -50 // Move view 150 points upward
    }
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    //    функция для очищения текстовых полей
    private func resetTextFields(){
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    //    функция для переключения между текст филдами с помощью клавиатуры
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    //    свичт кейс для переключения между текст филдами с помощью клавиатуры
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case userNameTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
            loginButtonPressedWithoutSender()
        }
    }
    
    //    скрываем клавиатуру тапом по экрану
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func forgotUserNameButtonPressed(_ sender: UIButton) {
        showAlert(title: "Sorry, but you need to know your login to enter.", message: "😔")
    }
    
    
    @IBAction func forgorPasswordButtonPressed(_ sender: UIButton) {
        guard let checkLogin = userNameTextField.text, !checkLogin.isEmpty else {
            showAlert(title: "Wrong User Name or Password", message: "One or all fields are empty")
            return
        }
        if let myPassword = keyChainClass.getKeyChainData(key: userNameTextField.text!) {
            let result = String(decoding: myPassword, as: UTF8.self)
            self.passwordReminder = result
        }
// если пользователь помнит свой логин, то напоминаем ему пароль
        showAlert(title: "For user: \(userNameTextField.text ?? "")", message: "Password is: \(passwordReminder)" )
    }
    
//    функция которая выполняется при нажатии кнопки логин
    @IBAction func loginButtonPressedWithoutSender() {
        submit()
        performSegue(withIdentifier: "toWelcomeScreen", sender: UIButton.self)
    }
    
//    описание сегвея который происходит при нажатии на кнопку логин
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
//      прерываем переход если поля пустые
        guard let checkLogin = userNameTextField.text, !checkLogin.isEmpty else {
            showAlert(title: "Wrong User Name or Password", message: "One or all fields are empty")
            return
        }
        guard let checkPassword = passwordTextField.text, !checkPassword.isEmpty else {
            showAlert(title: "Wrong User Name or Password", message: "One or all fields are empty")
            return
        }
        
        guard let welcomeVC = segue.destination as? WelcomeViewController else { return }
        welcomeVC.userGreetinLabel = userNameTextField.text ?? ""
        
        if let myPassword = keyChainClass.getKeyChainData(key: userNameTextField.text!) {
            let result = String(decoding: myPassword, as: UTF8.self)
            welcomeVC.userPasswordLabel = result
        }
        
        if let myCredentials = keyChainClass.getKeyChainData(key: userNameTextField.text!) {
            let result2 = String(decoding: myCredentials, as: UTF8.self)
            welcomeVC.userCred = result2
        }
        
        resetTextFields()
    }
}

// экстеншн для алертов
extension LoginViewController {
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.passwordTextField.text = ""
            self.userNameTextField.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
