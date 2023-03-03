//
//  WelcomeViewController.swift
//  story
//
//  Created by Marcin Blicharz on 07/02/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var login : String = ""
    var password : String = ""
    
    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = "Hi \(login), welcome in App!"
    }

}
