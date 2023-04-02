//
//  WelcomeViewController.swift
//  story
//
//  Created by Marcin Blicharz on 07/02/2023.
//

import UIKit

class WelcomeViewController: UIViewController, UITableViewDataSource {
    
    var login : String = ""
    var password : String = ""
    var restCosts = RestCosts()
    var link : String =  ""
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
        
        welcomeLabel.text = "Hi \(login), welcome in App!"
        print("Link: " + link)
        restCosts.getCostsInner(urlLink: link){
            print("Get data from JSON with success!")
            self.aclfj = self.restCosts.acl
            self.list_size = self.aclfj.count
            print("Size of aclfj is: " + String(self.list_size))
            if self.list_size > 0 {
                print("aclfj[0] (date): ", self.aclfj[0].date, ", (value): ", String(self.aclfj[0].value), ", (name): ", self.aclfj[0].name, ", (type): ", self.aclfj[0].type)
            } else {
                print("aclfj 0 sized")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Code Here
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Code Here
    }
}
