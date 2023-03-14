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
    var restCost = RestCosts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        restLogin.getLogins(urlLink: "http://localhost:8080/rest/getUsers")
        print("Size of login table is: " + String(restLogin.vm_logins.count))
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
        isLogin = false
        errorLabel.isHidden = true
        var pastMonday : Int = 0
        restLogin.getLogins(urlLink: "http://localhost:8080/rest/getUsers")
        print("Size of login table is: " + String(restLogin.vm_logins.count))
        for ApiUser in restLogin.vm_logins {
            if loginText.text!.caseInsensitiveCompare(ApiUser.name!) == .orderedSame && passwordText.text! == ApiUser.password! {
                print("USER: " + ApiUser.name! + ", PASS: " + ApiUser.password!)
                performSegue(withIdentifier: "goToWelcome", sender: self)
                isLogin = true
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
//                let currentDateComponents = calendar.component([.YearForWeekOfYear, .WeekOfYear ], fromDate: currentDate)
//                let prevMonday = Date.today().previous(.sunday)
//                let lastMonday = calendar.component(.yearForWeekOfYear, from: currentDate)
                let today = calendar.dateInterval(of: .day, for: currentDate)
                let currentMonth = calendar.dateInterval(of: .month, for: currentDate)
                let currentYear = calendar.dateInterval(of: .year, for: currentDate)
                if dayOfWeek == 2 {
                    print("Today is Monday")
                } else if dayOfWeek < 2 {
                    pastMonday = (2 - (7 + 1)) * -1
                    print("Monday was " + String(pastMonday) + "days ago")
                } else {
                    pastMonday = (2 - dayOfWeek) * -1
                    print("Monday was " + String(pastMonday) + "days ago")
                }
                dateComponent.day = pastMonday * -1
                let lastMonday = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                print("current week is: " + String(currentWeek) + "., day of week is: " + String(dayOfWeek) + "., day of month is: " + String(dayOfMonth) + "., first day of week: " + dateFormatterDay.string(from: lastMonday!))
                let costLink = "http://localhost:8080/rest/getCosts?from=" + dateFormatterDay.string(from: lastMonday!)
                print("link for current week costs is: '" + costLink + "'")
                restCost.getCosts(urlLink: costLink)
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

