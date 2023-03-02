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
    @StateObject var restLogin = RestLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
        restLogin.getLogins(urlLink: "http://localhost:8080/rest/getUsers")
        performSegue(withIdentifier: "goToWelcome", sender: self)
        
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
    }
}

