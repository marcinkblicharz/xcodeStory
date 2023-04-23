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
    var serverAddress : String = ""
//    let urlCosts =
    var linkCosts : String =  ""
    var linkIncomes : String =  ""
    var aclfj = [ApiCosts]()
    var ailfj = [ApiIncomes]()
    var listCosts_size : Int = 0
    var listIncomes_size : Int = 0
    var tableViewData = [String]()
    var dateFromCosts : Date = Date()
    var dateToCosts : Date = Date()
    var dateFromIncomes : Date = Date()
    var dateToIncomes : Date = Date()
//    var currentDate : Date?
//    var dateComponent : DateComponents?
    var calendar : Calendar = Calendar.current
    var activePanel : String = "listCosts"
    
    let dp = UIDatePicker()
    
    let gtoolbar = UIToolbar()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(identifier: "Europe/Amsterdam")
//        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    private var viewModel = CostViewModel()
    
    @IBOutlet weak var tableCosts: UITableView!
    @IBOutlet weak var tableIncome: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var rangeButton: UIButton!
    @IBOutlet weak var dateFrom: UIDatePicker!
    @IBOutlet weak var dateTo: UIDatePicker!
    @IBOutlet weak var buttonCosts: UIButton!
    @IBOutlet weak var buttonIncomes: UIButton!
    @IBOutlet weak var taDateFrom: UITextField!
    @IBOutlet weak var taDateTo: UITextField!
    @IBOutlet weak var stackViewScreen: UIStackView!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var toolbarFromDatepicker: UIDatePicker!
    @IBOutlet weak var toolbarToDatepicker: UIDatePicker!
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    @IBOutlet weak var labelDateFrom: UILabel!
    @IBOutlet weak var labelDateTo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableCosts.dataSource = self
        tableCosts.delegate = self
//        tableCosts.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableIncome.delegate = self
        tableIncome.dataSource = self
        
        activePanel = "listCosts"
        
        linkCosts = "http://" + serverAddress + ":8080/rest/getCosts?"
        linkIncomes = "http://" + serverAddress + ":8080/rest/getIncomes?"
        
        dateFrom.timeZone = TimeZone.init(identifier: "Europe/Amsterdam")
        dateTo.timeZone = TimeZone.init(identifier: "Europe/Amsterdam")
        dateFrom.maximumDate = Date()
        dateTo.maximumDate = Date()
        print("default datePicker is, from: ", dateFrom.date, ", to: ", dateTo.date)
//        dateFrom.
        
        welcomeLabel.text = "Hi \(login), welcome to App!"
        
        dateFromCosts = getLastMonday()
//        dateToCosts = dateTo.date
        dateToCosts = Date()
        dateFrom.date = dateFromCosts
        dateFromIncomes = getFirstDayOfMonth()
//        dateToIncomes = dateTo.date
        dateToIncomes = Date()
        print("after set initial datePicker is, from: ", dateFrom.date, ", to: ", dateTo.date)
        getCostsList(dateFrom: dateFormatter.string(from: dateFromCosts), dateTo: dateFormatter.string(from: dateToCosts))
        getIncomesList(dateFrom: dateFormatter.string(from: dateFromIncomes), dateTo: dateFormatter.string(from: dateToIncomes))
        
        setPullDownButtonRange()
//        setDefaultDateRange()
        
        taDateFrom.text = dateFormatter.string(from: dateFromCosts)
        taDateTo.text = dateFormatter.string(from: dateToCosts)
        
        dp.timeZone = TimeZone.init(identifier: "Europe/Amsterdam")
        dp.maximumDate = Date()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .date
        taDateFrom.inputView = dp
        taDateFrom.inputAccessoryView = fromDateToolbar()
        
//        taDateFrom.inputAccessoryView = setTAButFrom(false)
//        taDateFrom.isUserInteractionEnabled = false
        
        toolbarFromDatepicker.maximumDate = Date()
        toolbarToDatepicker.maximumDate = Date()
        let myFont = UIFont.init(name: "AmericanTypewriter", size: 14)
        buttonFrom.titleLabel!.font = myFont
//        buttonTo.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        buttonFrom.titleLabel?.text = dateFormatter.string(from: dateFromCosts)
//        buttonTo.titleLabel?.text = dateFormatter.string(from: dateToCosts)
//        buttonFrom.
        buttonFrom.setTitle(dateFormatter.string(from: dateFromCosts), for: .normal)
        buttonTo.setTitle(dateFormatter.string(from: dateToCosts), for: .normal)
        
        labelDateFrom.text = dateFormatter.string(from: dateFromCosts)
        labelDateFrom.textColor = .systemBlue
        labelDateTo.text = dateFormatter.string(from: Date())
        labelDateTo.textColor = .systemBlue
        let dateFromClick = UITapGestureRecognizer(target: self, action: #selector(laDaFrAction))
        labelDateFrom.isUserInteractionEnabled = true
        labelDateFrom.addGestureRecognizer(dateFromClick)
        let dateToClick = UITapGestureRecognizer(target: self, action: #selector(laDaToAction))
        labelDateTo.isUserInteractionEnabled = true
        labelDateTo.addGestureRecognizer(dateToClick)
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
        let sortedCosts = aclfj.sorted{$0.date < $1.date}
        let sortedIncomes = ailfj.sorted{$0.date < $1.date}
        var cell : UITableViewCell?
        if tableView == self.tableCosts {
            print("tableView_sortedCosts: " + String(sortedCosts.count))
            if sortedCosts.count > 0 {
                cell = tableCosts.dequeueReusableCell(withIdentifier: "TableCostsCell", for: indexPath)
                cell!.textLabel!.text = sortedCosts[indexPath.row].date + " - " + String(sortedCosts[indexPath.row].value) + " - " + sortedCosts[indexPath.row].name + " - " + sortedCosts[indexPath.row].type
                return cell!
            } else {
                cell = tableCosts.dequeueReusableCell(withIdentifier: "TableCostsCell", for: indexPath)
                cell!.textLabel!.text = ""
                self.tableCosts.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if tableView == self.tableIncome {
            print("tableView_sortedIncomes: " + String(sortedIncomes.count))
            if sortedIncomes.count > 0 {
                cell = tableIncome.dequeueReusableCell(withIdentifier: "TableIncomeCell", for: indexPath)
                cell!.textLabel!.text = sortedIncomes[indexPath.row].date + " - " + String(sortedIncomes[indexPath.row].value) + " - " + sortedIncomes[indexPath.row].name + " - " + sortedIncomes[indexPath.row].type
                return cell!
            } else {
                cell = tableIncome.dequeueReusableCell(withIdentifier: "TableIncomeCell", for: indexPath)
                cell!.textLabel!.text = ""
                self.tableIncome.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        return cell!
    }
    
    func updateTable (add : String) {
        tableViewData.append(add)
    }
    
    @IBAction func costButton(_ sender: UIButton) {
        tableCosts.isHidden = false
        tableIncome.isHidden = true
        dateFrom.date = dateFromCosts
        dateTo.date = dateToCosts
        buttonCosts.backgroundColor = UIColor.systemGray2
        buttonIncomes.backgroundColor = UIColor.systemGray2.withAlphaComponent(0.0)
        print("Show Costs and hide Incomes")
    }
    
    @IBAction func incomeButton(_ sender: UIButton) {
        tableCosts.isHidden = true
        tableIncome.isHidden = false
        dateFrom.date = dateFromIncomes
        dateTo.date = dateToIncomes
        buttonCosts.backgroundColor = UIColor.systemGray2.withAlphaComponent(0.0)
        buttonIncomes.backgroundColor = UIColor.systemGray2
        print("Show Incomes and hide Costs")
    }
    
    @IBAction func backDateToUpIn(_ sender: UIButton) {
        print("back date")
        let tmpDateFrom = dateFrom.date
        var dateComponent = DateComponents()
        print("range is: ", rangeButton.currentTitle)
        if rangeButton.currentTitle == "week" {
            dateComponent.day = -7
        } else if rangeButton.currentTitle == "2-weeks" {
            dateComponent.day = -14
        } else if rangeButton.currentTitle == "month" {
            dateComponent.month = -1
        }
        dateFrom.date = Calendar.current.date(byAdding: dateComponent, to: tmpDateFrom) ?? Date()
        print("dateFrom: ", dateFrom.date)
        if tableCosts.isHidden == false {
            dateFromCosts = dateFrom.date
            print("dateFromCosts: ", dateFromCosts.debugDescription)
            getCostsList(dateFrom: dateFormatter.string(from: dateFromCosts), dateTo: dateFormatter.string(from: dateTo.date))
        }
        if tableIncome.isHidden == false {
            dateFromIncomes = dateFrom.date
            print("dateFromIncomes: ", dateFromIncomes.debugDescription)
            getIncomesList(dateFrom: dateFormatter.string(from: dateFromIncomes), dateTo: dateFormatter.string(from: dateTo.date))
        }
    }
    
    @IBAction func nextDateToUpIn(_ sender: UIButton) {
        print("next date")
        let tmpDateTo = dateTo.date
        var dateComponent = DateComponents()
        print("range is: ", rangeButton.currentTitle)
        if rangeButton.currentTitle == "week" {
            dateComponent.day = 7
        } else if rangeButton.currentTitle == "2-weeks" {
            dateComponent.day = 14
        } else if rangeButton.currentTitle == "month" {
            dateComponent.month = 1
        }
        dateTo.date = Calendar.current.date(byAdding: dateComponent, to: tmpDateTo) ?? Date()
        print("dateTo: ", dateTo.date)
        if tableCosts.isHidden == false {
            dateToCosts = dateTo.date
            print("dateToCosts: ", dateToCosts.debugDescription)
            getCostsList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateToCosts))
        }
        if tableIncome.isHidden == false {
            dateToIncomes = dateTo.date
            print("dateToIncomes: ", dateToIncomes.debugDescription)
            getIncomesList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateToIncomes))
        }
    }
    
    @IBAction func moveBackDateToUpIn(_ sender: UIButton) {
        let tmpDateFrom = dateFrom.date
        let tmpDateTo = dateTo.date
        var dateComponent = DateComponents()
        if rangeButton.currentTitle == "week" {
            dateComponent.day = -7
        } else if rangeButton.currentTitle == "2-weeks" {
            dateComponent.day = -14
        } else if rangeButton.currentTitle == "month" {
            dateComponent.month = -1
        }
        dateFrom.date = Calendar.current.date(byAdding: dateComponent, to: tmpDateFrom) ?? Date()
        print("dateFrom: ", dateFrom.date)
        dateTo.date = Calendar.current.date(byAdding: dateComponent, to: tmpDateTo) ?? Date()
        print("dateTo: ", dateTo.date)
        if tableCosts.isHidden == false {
            dateFromCosts = dateFrom.date
            dateToCosts = dateTo.date
            print("dateFromCosts: ", dateFromCosts.debugDescription, "dateToCosts: ", dateToCosts.debugDescription)
            getCostsList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateTo.date))
        }
        if tableIncome.isHidden == false {
            dateFromIncomes = dateFrom.date
            dateToIncomes = dateTo.date
            print("dateToIncomes: ", dateToIncomes.debugDescription)
            getIncomesList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateTo.date))
        }
    }
    
    @IBAction func moveForwardDateToUpIn(_ sender: UIButton) {
        let tmpDateFrom = dateFrom.date
        let tmpDateTo = dateTo.date
        var dateComponent = DateComponents()
        if rangeButton.currentTitle == "week" {
            dateComponent.day = 7
        } else if rangeButton.currentTitle == "2-weeks" {
            dateComponent.day = 14
        } else if rangeButton.currentTitle == "month" {
            dateComponent.month = 1
        }
        dateFrom.date = Calendar.current.date(byAdding: dateComponent, to: tmpDateFrom) ?? Date()
        print("dateFrom: ", dateFrom.date)
        dateTo.date = Calendar.current.date(byAdding: dateComponent, to: tmpDateTo) ?? Date()
        print("dateTo: ", dateTo.date)
        if tableCosts.isHidden == false {
            dateFromCosts = dateFrom.date
            dateToCosts = dateTo.date
            print("dateFromCosts: ", dateFromCosts.debugDescription, "dateToCosts: ", dateToCosts.debugDescription)
            getCostsList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateTo.date))
        }
        if tableIncome.isHidden == false {
            dateFromIncomes = dateFrom.date
            dateToIncomes = dateTo.date
            print("dateToIncomes: ", dateToIncomes.debugDescription)
            getIncomesList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateTo.date))
        }
    }
    
    func setPullDownButtonRange(){
        let optionClosure = {(action: UIAction) in
            print("change date range to: " + action.title)
        }
        rangeButton.menu = UIMenu(children : [
            UIAction(title: "week", state: .on, handler: optionClosure),
            UIAction(title: "2-weeks", handler: optionClosure),
            UIAction(title: "month", handler: optionClosure)])
        rangeButton.showsMenuAsPrimaryAction = true
        rangeButton.changesSelectionAsPrimaryAction = true
    }
    
    @IBAction func changeDateFrom(_ sender: UIDatePicker) {
        if tableCosts.isHidden == false {
            print("dateFromCosts: ", dateFromCosts.debugDescription)
            dateFromCosts = dateFrom.date
            getCostsList(dateFrom: dateFormatter.string(from: dateFromCosts), dateTo: dateFormatter.string(from: dateTo.date))
        }
        if tableIncome.isHidden == false {
            print("dateFromIncomes: ", dateFromIncomes.debugDescription)
            dateFromIncomes = dateFrom.date
            getIncomesList(dateFrom: dateFormatter.string(from: dateFromIncomes), dateTo: dateFormatter.string(from: dateTo.date))
        }
        print("dateFrom: ", dateFrom.date)
        presentedViewController?.dismiss(animated: true)
    }
    
    @IBAction func changeDateTo(_ sender: UIDatePicker) {
        if tableCosts.isHidden == false {
            print("dateToCosts: ", dateToCosts.debugDescription)
            dateToCosts = dateTo.date
            getCostsList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateToCosts))
        }
        if tableIncome.isHidden == false {
            print("dateToIncomes: ", dateToIncomes.debugDescription)
            dateToIncomes = dateTo.date
            getIncomesList(dateFrom: dateFormatter.string(from: dateFrom.date), dateTo: dateFormatter.string(from: dateToIncomes))
        }
        print("dateTo: ", dateTo.date)
        presentedViewController?.dismiss(animated: true)
    }
    
    @IBAction func dateFromButton(_ sender: UIButton) {
        print("dateFromButton")
        if toolbarBottom.isHidden == false {
            toolbarBottom.isHidden = true
            toolbarFromDatepicker.isHidden = true
        } else if toolbarBottom.isHidden == true {
            toolbarBottom.isHidden = false
            toolbarFromDatepicker.isHidden = false
        }
        print("date: " + dateFormatter.string(from: dateFromCosts))
        buttonFrom.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        buttonFrom.titleLabel?.text = dateFormatter.string(from: dateFromCosts)
    }
    
    @IBAction func dateToButton(_ sender: UIButton) {
        print("dateToButton")
        if toolbarBottom.isHidden == false {
            toolbarBottom.isHidden = true
            toolbarFromDatepicker.isHidden = true
        } else if toolbarBottom.isHidden == true {
            toolbarBottom.isHidden = false
            toolbarFromDatepicker.isHidden = false
        }
        print("date: " + dateFormatter.string(from: dateFromCosts))
        buttonTo.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        buttonTo.titleLabel?.text = dateFormatter.string(from: dateToCosts)
    }
    
    @IBAction func addBtoolbarSet(_ sender: UIBarButtonItem) {
        print("addBtoolbarSet")
//        todayButton.setTitle(dateFormatter.string(from: toolbarDatepicker.date), for: .normal)
        
//        toolbarBottom.isHidden = true
//        toolbarDatepicker.isHidden = true
    }
    
    @IBAction func addBtoolbarToday(_ sender: UIBarButtonItem) {
        print("addBtoolbarToday")
//        toolbarDatepicker.date = Date()
    }
    
    @IBAction func addBtoolbarCancel(_ sender: UIBarButtonItem) {
        print("addBtoolbarCancel")
//        toolbarBottom.isHidden = true
//        toolbarDatepicker.isHidden = true
    }
    
    func showDateFrom () {
        
    }
    
    func setDefaultDateRange(){
        var currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -7
//        dateFromCosts = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print("dateFromCosts: " , dateFormatter.string(from: dateFromCosts))
//        dateFrom.setDate(dateFromCosts!, animated: true)
//        dateFrom.isSelected = true
        let dayOfMonth = calendar.component(.day, from: currentDate)
        dateComponent.day = (dayOfMonth - 1) * -1
//        dateFromIncomes = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print("dateFromIncomes: " , dateFormatter.string(from: dateFromIncomes))
    }
    
    @IBAction func taFromToUpIn(_ sender: UITextField) {
        print("taFromToUpIn")
    }
    
    @IBAction func taFromEdDiEn(_ sender: UITextField) {
        print("taFromEdDiEn")
    }
    
    func fromDateToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Set", style: .done, target: nil, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        let todayB : UIButton = UIButton()
        todayB.setTitle("Today", for: .normal)
        let todayButton = UIBarButtonItem(title: "Today", style: .done, target: nil, action: #selector(todayPressed))
//        todayButton.customView = todayB
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        cancelButton.tintColor = .gray
        todayButton.tintColor = .black
        toolbar.setItems([doneButton, flexibleSpace, todayButton, flexibleSpace, cancelButton], animated: true)
        
//        self.stackViewScreen.isUserInteractionEnabled = false
        
        return toolbar
    }
    
    @objc func donePressed() {
        self.taDateFrom.text = dateFormatter.string(from: dp.date)
        self.view.endEditing(true)
        self.taDateFrom.isEnabled = true
    }
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
        self.taDateFrom.isEnabled = true
    }
    
    @objc func todayPressed() {
        dp.date = Date()
//        self.view.endEditing(true)
        self.taDateFrom.isEnabled = true
    }
    
    @objc func laDaFrAction(){
        print("laDaFrAction")
        toolbarToDatepicker.isHidden = true
        if toolbarBottom.isHidden == false {
            toolbarBottom.isHidden = true
            toolbarFromDatepicker.isHidden = true
        } else if toolbarBottom.isHidden == true {
            toolbarBottom.isHidden = false
            toolbarFromDatepicker.isHidden = false
        }
    }
    
    @objc func laDaToAction(){
        print("laDaToAction")
        toolbarFromDatepicker.isHidden = true
        if toolbarBottom.isHidden == false {
            toolbarBottom.isHidden = true
            toolbarToDatepicker.isHidden = true
        } else if toolbarBottom.isHidden == true {
            toolbarBottom.isHidden = false
            toolbarToDatepicker.isHidden = false
        }
    }
    
    func setTAButFrom(active : Bool) {
        self.taDateFrom.isEnabled = active
    }
    
    @IBAction func qqq(_ sender: UITextField) {
//        taDateFrom.inputView = dp
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//        toolbar.setItems([doneButton], animated: true)
//        sleep(1)
//        self.taDateFrom.isEnabled = false
        print("qqq")
    }
    
    func getCostsList(dateFrom : String, dateTo : String) {
        aclfj.removeAll()
        self.aclfj.removeAll()
	//        let count = self.tableCosts.tab
//        self.tableCosts.deleteRows(at: (0..<count).map({ (i) in IndexPath(row: i, section: 0)}), with: .automatic)
        print("getCostsList - dateFrom: " + dateFrom + ", dateTo: " + dateTo)
        var addLink = ""
        if dateFrom.count > 0 {
            addLink = addLink + "from=" + dateFrom
        }
        if dateFrom.count > 0 && dateTo.count > 0 {
            addLink = addLink + "&"
        }
        if dateTo.count > 0 {
            addLink = addLink + "to=" + dateTo
        }
        print("LinkCosts: " + linkCosts + addLink)
        restCosts.getCostsInner(urlLink: linkCosts + addLink){
//            aclfj.removeAll()
            self.aclfj.removeAll()
            print("Get data CostsList from JSON with success!")
            self.aclfj = self.restCosts.acl
            print("size of inside 'aclfj' is: " + String(self.aclfj.count))
            self.listCosts_size = self.aclfj.count
            print("Size of aclfj is: " + String(self.listCosts_size))
            if self.listCosts_size > 0 {
                print("aclfj[0] (date): ", self.aclfj[0].date, ", (value): ", String(self.aclfj[0].value), ", (name): ", self.aclfj[0].name, ", (type): ", self.aclfj[0].type, ", (color): ", self.aclfj[0].color + "ff")
                self.tableCosts.register(UITableViewCell.self, forCellReuseIdentifier: "TableCostsCell")
                self.tableCosts.dataSource = self
                self.tableCosts.reloadData()
            } else {
                self.tableCosts.register(UITableViewCell.self, forCellReuseIdentifier: "TableCostsCell")
                self.tableCosts.dataSource = self
                self.tableCosts.reloadData()
                print("aclfj 0 sized")
            }
        }
        print("size of outside 'aclfj' is: " + String(self.aclfj.count))
    }
    
    func getIncomesList(dateFrom : String, dateTo : String) {
        ailfj.removeAll()
        self.ailfj.removeAll()
        self.tableIncome.reloadData()
        print("getIncomesList - dateFrom: " + dateFrom + ", dateTo: " + dateTo)
        var addLink = ""
        if dateFrom.count > 0 {
            addLink = addLink + "from=" + dateFrom
        }
        if dateFrom.count > 0 && dateTo.count > 0 {
            addLink = addLink + "&"
        }
        if dateTo.count > 0 {
            addLink = addLink + "to=" + dateTo
        }
        print("linkIncomes: " + linkIncomes + addLink)
        restIncomes.getIncomes(urlLink: linkIncomes + addLink){
//            ailfj.removeAll()
            self.ailfj.removeAll()
            print("Get data IncomesList from JSON with success!")
            self.ailfj = self.restIncomes.ail
            print("size of inside 'ailfj' is: " + String(self.ailfj.count))
            self.listIncomes_size = self.ailfj.count
            print("Size of ailfj is: " + String(self.listIncomes_size))
            if self.listIncomes_size > 0 {
                print("ailfj[0] (date): ", self.ailfj[0].date, ", (value): ", String(self.ailfj[0].value), ", (name): ", self.ailfj[0].name, ", (type): ", self.ailfj[0].type, ", (color): ", self.ailfj[0].color + "ff")
                self.tableIncome.register(UITableViewCell.self, forCellReuseIdentifier: "TableIncomeCell")
                self.tableIncome.dataSource = self
                self.tableIncome.reloadData()
            } else {
                self.tableIncome.register(UITableViewCell.self, forCellReuseIdentifier: "TableIncomeCell")
                self.tableIncome.dataSource = self
                self.tableIncome.reloadData()
                print("ailfj 0 sized")
            }
        }
        print("size of outside 'ailfj' is: " + String(self.ailfj.count))
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
        print("current week is: " + String(currentWeek) + "., day of week is: " + String(dayOfWeek) + "., day of month is: " + String(dayOfMonth) + "., first day of week: " + dateFormatter.string(from: lastMonday!))
        return lastMonday!
    }
    
    func getFirstDayOfMonth() -> Date {
        var calendar = Calendar.current
        let currentDate = Date()
        var dateComponent = DateComponents()
        let dayOfMonth = calendar.component(.day, from: currentDate)
        dateComponent.day = (dayOfMonth - 1) * -1 //- 7
        let firstDay = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print("current day of month is: " + String(dayOfMonth) + "., first day of month: " + dateFormatter.string(from: firstDay!))
        return firstDay!
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
