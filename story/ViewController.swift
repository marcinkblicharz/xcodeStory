//
//  ViewController.swift
//  story
//
//  Created by Marcin Blicharz on 06/02/2023.
//

import UIKit
import Foundation
import SwiftUI

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var setServerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var customAddress: UITextField!
    var restLogin = RestLogin()
    var isLogin : Bool = false
    var restCost = RestCosts()
    var statusLink : String! = ""
    var serverAddress : String! = ""
    @State var def_srv_add : String = UserDefaults.standard.string(forKey: "SERVER_ADDRESS") ?? ""
    @State var in_def_srv_add : String = ""
    var connectionStatus : Bool = false
    
    private let dateFormatterDay: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginText.delegate = self
        self.passwordText.delegate = self
        self.customAddress.delegate = self
        customAddress.text = def_srv_add
        setPullDownServerButton()
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
        isLogin = false
        errorLabel.isHidden = true
        
        
        if setServerButton.currentTitle == "local" {
            serverAddress = "localhost:8080"
        } else if setServerButton.currentTitle == "remote" {
            serverAddress = "192.168.1.69:8080"
        } else if setServerButton.currentTitle == "custom" {
            serverAddress = customAddress.text
            if serverAddress.count > 0 {
                in_def_srv_add = serverAddress
                UserDefaults.standard.set(customAddress.text, forKey: "SERVER_ADDRESS")
                def_srv_add = in_def_srv_add
                print("Set ADDRESS: ", def_srv_add, " - from: ", serverAddress!, ", in_def_arv_add: ", in_def_srv_add)
            }
        }
        
        statusLink = "http://" + serverAddress + "/rest/getStatus"
        print("\nSize of login table is: " + String(restLogin.vm_logins.count))
        
        restLogin.getStatus(urlLink: statusLink){
            print("restLogin.vm_status: ", self.restLogin.vm_status)
            if self.restLogin.vm_status == "OK" {
                self.connectionStatus = true
                print("connectionStatus: ", String(self.connectionStatus))
            }
        }
        
        restLogin.getLogin(urlLink: "http://" + serverAddress + "/rest/getLogin?name=" + loginText.text! + "&password=" + passwordText.text!){
            if self.loginText.text!.caseInsensitiveCompare(self.restLogin.vm_login.name) == .orderedSame && self.passwordText.text! == self.restLogin.vm_login.password {
                print("Get data from JSON, user: " + self.loginText.text! + ", password: " + self.passwordText.text! + " with success!")
                self.performSegue(withIdentifier: "goToWelcome", sender: self)
                self.isLogin = true
            } else {
                print("Get data from JSON, user: " + self.loginText.text! + ", password: " + self.passwordText.text! + " with error!")
                self.errorLabel.textColor = UIColor.red
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Login or password is incorrect!"
            }
        }
        if restLogin.error == true {
            print("Could not connect to the server!")
//            self.errorLabel.textColor = UIColor.red
//            self.errorLabel.isHidden = false
//            self.errorLabel.text = "Could not connect to the server!"
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
            if let serverAddress = self.serverAddress {
                destinationVC?.serverAddress = serverAddress
            }
        }
    }
    
    func setPullDownServerButton(){
        let optionClosure = {(action: UIAction) in
            print("change server to: " + action.title)
            if self.setServerButton.currentTitle == "custom" {
                self.customAddress.isHidden = false
            } else {
                self.customAddress.isHidden = true
            }
        }
        setServerButton.menu = UIMenu(children : [
            UIAction(title: "local", state: .on, handler: optionClosure),
            UIAction(title: "remote", handler: optionClosure),
            UIAction(title: "custom", handler: optionClosure)])
        setServerButton.showsMenuAsPrimaryAction = true
        setServerButton.changesSelectionAsPrimaryAction = true
    }
    
    @IBAction func serverButton(_ sender: UIButton) {
        print("serverButton - ACTION")
        if setServerButton.currentTitle == "custom" {
            customAddress.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


