//
//  WelcomeViewController.swift
//  story
//
//  Created by Marcin Blicharz on 07/02/2023.
//

import UIKit

class WelcomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var login : String = ""
    var password : String = ""
    var restCosts = RestCosts()
    var restIncomes = RestIncomes()
    var linkCosts : String =  ""
    var linkIncomes : String =  ""
    var aclfj = [ApiCosts]()
    var ailfj = [ApiIncomes]()
    var listCosts_size : Int = 0
    var listIncomes_size : Int = 0
    var tableViewData = [String]()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    private var viewModel = CostViewModel()
    
    @IBOutlet weak var tableCosts: UITableView!
    @IBOutlet weak var tableIncome: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableCosts.dataSource = self
        tableCosts.delegate = self
//        tableCosts.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableIncome.delegate = self
        tableIncome.dataSource = self
        
        welcomeLabel.text = "Hi \(login), welcome to App!"
        print("LinkCosts: " + linkCosts)
        restCosts.getCostsInner(urlLink: linkCosts){
            print("Get data CostsList from JSON with success!")
            self.aclfj = self.restCosts.acl
            print("size of inside 'aclfj' is: " + String(self.aclfj.count))
            self.listCosts_size = self.aclfj.count
            print("Size of aclfj is: " + String(self.listCosts_size))
            if self.listCosts_size > 0 {
                print("aclfj[0] (date): ", self.aclfj[0].date, ", (value): ", String(self.aclfj[0].value), ", (name): ", self.aclfj[0].name, ", (type): ", self.aclfj[0].type, ", (color): ", self.aclfj[0].color + "ff")
//                for element in 0...self.aclfj.count-1 {
//                    self.tableViewData.append(self.aclfj[element].date + " - " + String(self.aclfj[element].value) + " - " + self.aclfj[element].name + " - " + self.aclfj[element].type)
//                }
                self.tableViewData.append("aaaa_cost")
                self.tableCosts.register(UITableViewCell.self, forCellReuseIdentifier: "TableCostsCell")
                self.tableCosts.dataSource = self
                self.tableCosts.reloadData()
            } else {
                print("aclfj 0 sized")
            }
        }
        print("size of outside 'aclfj' is: " + String(self.aclfj.count))
        restIncomes.getIncomes(urlLink: linkIncomes){
            print("Get data IncomesList from JSON with success!")
            self.ailfj = self.restIncomes.ail
            print("size of inside 'ailfj' is: " + String(self.ailfj.count))
            self.listIncomes_size = self.ailfj.count
            print("Size of ailfj is: " + String(self.listIncomes_size))
            if self.listIncomes_size > 0 {
                print("ailfj[0] (date): ", self.ailfj[0].date, ", (value): ", String(self.ailfj[0].value), ", (name): ", self.ailfj[0].name, ", (type): ", self.ailfj[0].type, ", (color): ", self.ailfj[0].color + "ff")
//                for element in 0...self.ailfj.count-1 {
//                    self.tableViewData.append(self.ailfj[element].date + " - " + String(self.ailfj[element].value) + " - " + self.ailfj[element].name + " - " + self.ailfj[element].type)
//                }
                self.tableViewData.append("aaaa_income")
                self.tableIncome.register(UITableViewCell.self, forCellReuseIdentifier: "TableIncomeCell")
                self.tableIncome.dataSource = self
                self.tableIncome.reloadData()
            } else {
                print("ailfj 0 sized")
            }
        }
        print("size of outside 'ailfj' is: " + String(self.ailfj.count))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tableViewData.count
        var size : Int?
        if tableView == self.tableCosts {
            size = self.listCosts_size
        } else if tableView == self.tableIncome {
            size =  self.listIncomes_size
        } else {
            size = 0
        }
        return size!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
//        cell.textLabel?.text = self.tableViewData[indexPath.row]
////        let color : String = self.aclfj[indexPath.row].color + "ff"
////        cell.backgroundColor = UIColor(hex: color)
//        return cell
        var cell : UITableViewCell?
        if tableView == self.tableCosts {
            cell = tableCosts.dequeueReusableCell(withIdentifier: "TableCostsCell", for: indexPath)
            cell!.textLabel!.text = self.aclfj[indexPath.row].date + " - " + String(self.aclfj[indexPath.row].value) + " - " + self.aclfj[indexPath.row].name + " - " + self.aclfj[indexPath.row].type
            return cell!
        } else if tableView == self.tableIncome {
            cell = tableIncome.dequeueReusableCell(withIdentifier: "TableIncomeCell", for: indexPath)
            cell!.textLabel!.text = self.ailfj[indexPath.row].date + " - " + String(self.ailfj[indexPath.row].value) + " - " + self.ailfj[indexPath.row].name + " - " + self.ailfj[indexPath.row].type
            return cell!
        }
        return cell!
    }
    
    func updateTable (add : String) {
        tableViewData.append(add)
    }
    
    @IBAction func costButton(_ sender: UIButton) {
        tableCosts.isHidden = false
        tableIncome.isHidden = true
    }
    
    @IBAction func incomeButton(_ sender: UIButton) {
        tableCosts.isHidden = true
        tableIncome.isHidden = false
    }
    
    @IBAction func backDate(_ sender: UIButton) {
    }
    
    @IBAction func nextDate(_ sender: UIButton) {
    }
    
    @IBAction func fromDate(_ sender: UIButton) {
    }
    
    @IBAction func toDate(_ sender: UIButton) {
    }
    
    @IBAction func rangeDate(_ sender: UIButton) {
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
