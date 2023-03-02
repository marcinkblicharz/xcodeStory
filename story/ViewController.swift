//
//  ViewController.swift
//  story
//
//  Created by Marcin Blicharz on 06/02/2023.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var restLogin = RestLogin()
    var isLogin : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        restLogin.getLogins(urlLink: "http://localhost:8080/rest/getUsers")
        print("Size of login table is: " + String(restLogin.vm_logins.count))
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
        isLogin = false
        errorLabel.isHidden = true
        restLogin.getLogins(urlLink: "http://localhost:8080/rest/getUsers")
        print("Size of login table is: " + String(restLogin.vm_logins.count))
        for ApiUser in restLogin.vm_logins {
            if loginText.text! == ApiUser.name! && passwordText.text! == ApiUser.password! {
                print("USER: " + ApiUser.name! + ", PASS: " + ApiUser.password!)
                performSegue(withIdentifier: "goToWelcome", sender: self)
                isLogin = true
            }
        }
        if !isLogin {
            errorLabel.textColor = UIColor.red
            errorLabel.isHidden = false
            errorLabel.text = "Login or password is incorrect!"
            print("Login or password is incorrect!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWelcome" {
            let destinationVC = segue.destination as? WelcomeViewController
            if let login = loginText.text {
                destinationVC?.login = login
            }
            if let password = passwordText.text {
                destinationVC?.password = password
            }
        }
//        restLogin.getLogins(urlLink: "http://localhost:8080/rest/getUsers")
//        print("Size of login table is: " + String(restLogin.vm_logins.count))
    }
}

