//
//  ViewController.swift
//  story
//
//  Created by Marcin Blicharz on 06/02/2023.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var setServerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var customAddress: UITextField!
    var restLogin = RestLogin()
    var isLogin : Bool = false
    var restCost = RestCosts()
    var costLink : String! = ""
    var incomeLink : String! = ""
    var serverAddress : String! = ""
    
    private let dateFormatterDay: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customAddress.delegate = self
        setPullDownServerButton()
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
        isLogin = false
        errorLabel.isHidden = true
//        costLink = "http://localhost:8080/rest/getCosts?from=" + getLastMonday()
        
        
        if setServerButton.currentTitle == "local" {
            serverAddress = "localhost:8080"
        } else if setServerButton.currentTitle == "remote" {
            serverAddress = "192.168.1.69:8080"
        } else if setServerButton.currentTitle == "custom" {
            serverAddress = customAddress.text
        }
        
        costLink = "http://" + serverAddress + "/rest/getCosts?from=" + dateFormatterDay.string(from: getLastMonday())
        incomeLink = "http://" + serverAddress + "/rest/getIncomes?from=" + dateFormatterDay.string(from: getFirstDayOfMonth())
        print("\nSize of login table is: " + String(restLogin.vm_logins.count))
        
        restLogin.getLogin(urlLink: "http://" + serverAddress + "/rest/getLogin?name=" + loginText.text! + "&password=" + passwordText.text!){
            if self.loginText.text!.caseInsensitiveCompare(self.restLogin.vm_login.name) == .orderedSame && self.passwordText.text! == self.restLogin.vm_login.password {
                print("Get data from JSON, user: " + self.loginText.text! + ", password: " + self.passwordText.text! + " with success!")
                self.performSegue(withIdentifier: "goToWelcome", sender: self)
                self.isLogin = true
//                self.linkText.text = self.costLink
                print("link for current week costs is: '" + self.costLink! + "'")
                print("link for current day incomes is: '" + self.incomeLink! + "'")
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
//            if let linkCosts = self.costLink {
//                destinationVC?.linkCosts = linkCosts
//            }
            if let linkIncomes = self.incomeLink {
                destinationVC?.linkIncomes = linkIncomes
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
    
    func getLastMonday() -> Date {
        var pastMonday : Int = 0
        let dateFormatterFull = DateFormatter()
        dateFormatterFull.dateFormat = "YYYY/MM/dd HH:mm:ss"
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
        //change if week is empty
        dateComponent.day = pastMonday * -1 //- 7
        let lastMonday = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print("current week is: " + String(currentWeek) + "., day of week is: " + String(dayOfWeek) + "., day of month is: " + String(dayOfMonth) + "., first day of week: " + dateFormatterDay.string(from: lastMonday!))
        return lastMonday!
    }
    
    func getFirstDayOfMonth() -> Date {
        var calendar = Calendar.current
        let currentDate = Date()
        var dateComponent = DateComponents()
        let dayOfMonth = calendar.component(.day, from: currentDate)
        dateComponent.day = (dayOfMonth - 1) * -1 //- 7
        let firstDay = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print("current day of month is: " + String(dayOfMonth) + "., first day of month: " + dateFormatterDay.string(from: firstDay!))
        return firstDay!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return customAddress.resignFirstResponder()
    }
}

