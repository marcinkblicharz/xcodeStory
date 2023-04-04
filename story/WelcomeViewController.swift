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
    var tableViewData = [String]()
    
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
        restCosts.getCostsInner(urlLink: link){ //[self] in
//            sleep(4)
            print("Get data from JSON with success!")
//            aclfj = restCosts.acl
            self.aclfj = self.restCosts.acl
            print("size of inside 'aclfj' is: " + String(self.aclfj.count))
            self.list_size = self.aclfj.count
            print("Size of aclfj is: " + String(self.list_size))
            if self.list_size > 0 {
                print("aclfj[0] (date): ", self.aclfj[0].date, ", (value): ", String(self.aclfj[0].value), ", (name): ", self.aclfj[0].name, ", (type): ", self.aclfj[0].type)
                for element in 0...self.aclfj.count-1 {
                    self.tableViewData.append(self.aclfj[element].date + " - " + String(self.aclfj[element].value) + " - " + self.aclfj[element].name + " - " + self.aclfj[element].type)
                }
                self.tableCosts.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
                self.updateTable(add: "dodaj")
                self.tableCosts.dataSource = self
//                self.superclass?.viewDidLoad()
//                self.superclass?.loadView()
            } else {
                print("aclfj 0 sized")
            }
        }
//        tableViewData.append("Is one row!")
        print("size of outside 'aclfj' is: " + String(self.aclfj.count))
////        tableViewData.append(aclfj[0].date)
//        tableCosts.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
//        tableCosts.dataSource = self
//        sleep(4)
        super.loadView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
        return self.tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = self.tableViewData[indexPath.row]
        return cell
    }
    
    func updateTable (add : String) {
        tableViewData.append(add)
    }
    
//    func wait() async {
//        try await Task.sleep(nanoseconds: UInt64(5.0 * Double(NSEC_PER_SEC)))
//    }
    
//    func getApiCosts(urlLink: String) -> [ApiCosts] {
//        restCosts.getCostsInner(urlLink: urlLink){
//            guard let put = self.restCosts.acl else { return }
//            return put
//        }
//
//    }
}
