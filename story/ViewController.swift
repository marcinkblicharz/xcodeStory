//
//  ViewController.swift
//  story
//
//  Created by Marcin Blicharz on 06/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
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

