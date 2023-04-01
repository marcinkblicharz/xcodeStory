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
    var restCosts = RestCosts()
    var link : String =  "http://localhost:8080/rest/getCosts?from=2023-03-20"
//    var acl : [ApiCosts] = []
//    var acl = [ApiCosts]()
//    var acll = [ApiCosts]()
    var aclfj = [ApiCosts]()
    var list_size : Int = 0
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    private var viewModel = CostViewModel()
    
    @IBOutlet weak var tableCosts: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        link = "http://localhost:8080/rest/getCosts?from=2023-03-13"
        
        welcomeLabel.text = "Hi \(login), welcome in App!"
        print("Link: " + link)
        restCosts.getCostsInner(urlLink: link){
            print("Get data from JSON with success!")
            self.aclfj = self.restCosts.acl
            self.list_size = self.aclfj.count
            print("Size of aclfj is: " + String(self.list_size))
            if self.list_size > 0 {
                print("aclfj[0] (date): ", self.aclfj[0].date)
            } else {
                print("aclfj 0 sized")
            }
        }
    }
}
