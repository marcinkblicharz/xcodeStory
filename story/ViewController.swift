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
//    @IBOutlet weak var linkText: UITextField!
    var restLogin = RestLogin()
    var isLogin : Bool = false
    var restCost = RestCosts()
    var costLink : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
        isLogin = false
        errorLabel.isHidden = true
        costLink = "http://localhost:8080/rest/getCosts?from=" + getLastMonday()
        print("\nSize of login table is: " + String(restLogin.vm_logins.count))
        
        restLogin.getLogin(urlLink: "http://localhost:8080/rest/getLogin?name=" + loginText.text! + "&password=" + passwordText.text!){
            if self.loginText.text!.caseInsensitiveCompare(self.restLogin.vm_login.name) == .orderedSame && self.passwordText.text! == self.restLogin.vm_login.password {
                print("Get data from JSON, user: " + self.loginText.text! + ", password: " + self.passwordText.text! + " with success!")
                self.performSegue(withIdentifier: "goToWelcome", sender: self)
                self.isLogin = true
//                self.linkText.text = self.costLink
                print("link for current week costs is: '" + self.costLink! + "'")
            } else {
                print("Get data from JSON, user: " + self.loginText.text! + ", password: " + self.passwordText.text! + " with error!")
                self.errorLabel.textColor = UIColor.red
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Login or password is incorrect!"
            }
        }
        if restLogin.error == true {
            print("Could not connect to the server!")
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
            if let link = self.costLink {
                destinationVC?.link = link
            }
        }
    }
    
    func getLastMonday() -> String {
        var pastMonday : Int = 0
        let dateFormatterFull = DateFormatter()
        dateFormatterFull.dateFormat = "YYYY/MM/dd HH:mm:ss"
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "YYYY-MM-dd"
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let currentDate = Date()
        var dateComponent = DateComponents()
        let currentWeek = calendar.component(.weekOfYear, from: currentDate)
        let dayOfWeek = calendar.component(.weekday, from: currentDate)
        let dayOfMonth = calendar.component(.day, from: currentDate)
        if dayOfWeek == 2 {
            print("Today is Monday")
        } else if dayOfWeek < 2 {
            pastMonday = (2 - (7 + 1)) * -1
            print("Monday was " + String(pastMonday) + "days ago")
        } else {
            pastMonday = (2 - dayOfWeek) * -1
            print("Monday was " + String(pastMonday) + "days ago")
        }
        dateComponent.day = pastMonday * -1 //- 7
        let lastMonday = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print("current week is: " + String(currentWeek) + "., day of week is: " + String(dayOfWeek) + "., day of month is: " + String(dayOfMonth) + "., first day of week: " + dateFormatterDay.string(from: lastMonday!))
        return dateFormatterDay.string(from: lastMonday!)
    }
}

